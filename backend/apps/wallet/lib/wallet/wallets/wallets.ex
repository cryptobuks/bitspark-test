defmodule Wallet.Wallets do
  @moduledoc """
  The Wallets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Wallet.Repo

  alias Lightning
  alias Wallet.Wallets

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets do
    Repo.all(Wallets.Wallet)
  end

  @doc """
  Gets a single wallet.

  Raises `Ecto.NoResultsError` if the Wallet does not exist.

  ## Examples

      iex> get_wallet!(123)
      %Wallet{}

      iex> get_wallet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet!(id) do
    wallet = Repo.get!(Wallets.Wallet, id)

    %{wallet | balance: get_wallet_balance(wallet)}
  end

  def get_or_create_wallet!(user) do
    wallet = case Repo.get_by(Wallets.Wallet, user_id: user.id) do
               nil ->
                 {:ok, wallet} = create_wallet(%{"user_id" => user.id})
                 {:ok, _trn} = create_funding_transaction(wallet)
                 wallet
               wallet -> wallet
             end

    %{wallet | balance: get_wallet_balance(wallet)}
  end

  def get_wallet_balance(wallet) do
    q = from t in Wallets.Transaction,
      select: sum(t.msatoshi),
      where: t.state in ^[
        Wallets.Transaction.approved, Wallets.Transaction.initial
      ] and t.wallet_id == ^wallet.id

    # SUM of integers in postgresql results in decimal, but we want Integer (we
    # know it's OK as there are only 21M BTC)
    Decimal.to_integer(Repo.one(q) || Decimal.new(0))
  end

  @doc """
  Creates a wallet.

  ## Examples

      iex> create_wallet(%{field: value})
      {:ok, %Wallet{}}

      iex> create_wallet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet(attrs \\ %{}) do
    %Wallets.Wallet{}
    |> Wallets.Wallet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet.

  ## Examples

      iex> update_wallet(wallet, %{field: new_value})
      {:ok, %Wallet{}}

      iex> update_wallet(wallet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet(%Wallets.Wallet{} = wallet, attrs) do
    wallet
    |> Wallets.Wallet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Wallet.

  ## Examples

      iex> delete_wallet(wallet)
      {:ok, %Wallet{}}

      iex> delete_wallet(wallet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet(%Wallets.Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{source: %Wallet{}}

  """
  def change_wallet(%Wallets.Wallet{} = wallet) do
    Wallets.Wallet.changeset(wallet, %{})
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Wallets.Transaction)
  end

  def list_transactions(%Wallets.Wallet{} = wallet) do
    q = from t in Wallets.Transaction,
      select: t,
      where: t.wallet_id == ^wallet.id,
      order_by: [desc: t.inserted_at]

    Repo.all(q)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Wallets.Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Wallets.Transaction{}
    |> Wallets.Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_funding_transaction(wallet) do
    attrs = %{
      wallet_id: wallet.id,
      description: "Funding transaction",
      msatoshi: Bitcoin.to_msatoshi({"10", :mbtc}),
      state: "approved"
    }
    %Wallets.Transaction{}
    |> Wallets.Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Pay lightning invoice.

  ## Examples

  iex> pay_invoice(%{invoice: invoice})
  {:ok, %Transaction{}}

  iex> pay_invoice(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def pay_invoice(wallet_id, invoice) do
    {:ok, payload} = Lightning.decode_invoice(Wallet.lightning_config, invoice)

    # initial
    {:ok, trn} = create_transaction(
      %{"wallet_id" => wallet_id,
        "invoice" => invoice,
        "state" => "initial",
        "msatoshi" => -payload.msatoshi,
        "description" => payload.description})

    # check balance
    %{balance: balance} = get_wallet!(wallet_id)

    # process
    update = if balance < 0 do
      Logger.info "Failed to process transaction [#{trn.id}]. " <>
        "Error: Non-sufficient funds"
      %{state: Wallets.Transaction.declined, response: "NSF"}
    else
      case Lightning.pay_invoice(Wallet.lightning_config, invoice) do
        {:ok, payload} ->
          %{state: Wallets.Transaction.approved, response: payload}

        {:error, error} ->
          Logger.error "Failed to process transaction [#{trn.id}]. " <>
            "Error: #{inspect error}"
          %{state: Wallets.Transaction.declined, response: error}
      end
    end

    # update trn with result
    with {:ok, processed_transaction} <- update_transaction(trn, Enum.into(
                  %{processed_at: NaiveDateTime.utc_now,
                    response: Poison.encode!(update.response)},
                  update))
    do
      Wallet.Log.processed_transaction(processed_transaction)
      {:ok, processed_transaction}
    else
      err -> err
    end

  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Wallets.Transaction{} = transaction, attrs) do
    transaction
    |> Wallets.Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Wallets.Transaction{} = transaction) do
    Wallets.Transaction.changeset(transaction, %{})
  end
end
