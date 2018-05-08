defmodule WalletApi.Wallets do
  @moduledoc """
  The Wallets context.
  """

  import Ecto.Query, warn: false
  alias WalletApi.Repo

  alias WalletApi.Lightning
  alias WalletApi.Wallets.Wallet
  alias WalletApi.Wallets.Transaction

  @doc """
  Returns the list of wallets.

  ## Examples

      iex> list_wallets()
      [%Wallet{}, ...]

  """
  def list_wallets do
    Repo.all(Wallet)
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
    wallet = Repo.get!(Wallet, id)

    %{wallet | balance: get_wallet_balance(wallet)}
  end

  def get_or_create_wallet!(user) do
    wallet = case Repo.get_by(Wallet, user_id: user.id) do
               nil ->
                 {:ok, wallet} = create_wallet(%{"user_id" => user.id})
                 {:ok, _trn} = create_funding_transaction(wallet)
                 wallet
               wallet -> wallet
             end

    %{wallet | balance: get_wallet_balance(wallet)}
  end

  def get_wallet_balance(wallet) do
    q = from t in Transaction,
      select: sum(t.msatoshi),
      where: t.state == "approved" and t.wallet_id == ^wallet.id

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
    %Wallet{}
    |> Wallet.changeset(attrs)
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
  def update_wallet(%Wallet{} = wallet, attrs) do
    wallet
    |> Wallet.changeset(attrs)
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
  def delete_wallet(%Wallet{} = wallet) do
    Repo.delete(wallet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet changes.

  ## Examples

      iex> change_wallet(wallet)
      %Ecto.Changeset{source: %Wallet{}}

  """
  def change_wallet(%Wallet{} = wallet) do
    Wallet.changeset(wallet, %{})
  end

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
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
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def create_funding_transaction(wallet) do
    attrs = %{
      wallet_id: wallet.id,
      description: "Funding transaction",
      msatoshi: Bitcoin.to_msatoshi({"5.1", :mbtc}),
      state: "approved"
    }
    %Transaction{}
    |> Transaction.changeset(attrs)
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
    {:ok, payload} = Lightning.decode_invoice(invoice)

    transaction_params = %{
      "wallet_id" => wallet_id,
      "invoice" => invoice,
      "state" => "approved",
      "msatoshi" => -payload.msatoshi,
      "description" => "hello"
    }

    %Transaction{}
    |> Transaction.changeset(transaction_params)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
