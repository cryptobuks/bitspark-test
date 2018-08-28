defmodule Wallet.Wallets do
  @moduledoc """
  The Wallets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Wallet.Repo

  alias Lightning
  alias Wallet.Wallets
  alias Wallet.Validation

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
    |> Enum.map(&postprocess_transaction/1)
  end

  def list_transactions(%Wallets.Wallet{} = wallet) do
    q = from t in Wallets.Transaction,
      select: t,
      where: t.wallet_id == ^wallet.id,
      order_by: [desc: t.inserted_at]

    Repo.all(q)
    |> Enum.map(&postprocess_transaction/1)
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
  def get_transaction!(id), do: Repo.get!(Wallets.Transaction, id) |> postprocess_transaction

  @doc """
  Gets a transaction for given claim token (makes sure that it respects expiration).

  ## Example

      iex> get_transaction_by_token("a1b8bb02-9db5-4073-808f-e6fb62cab71b")
      {:ok, %Transaction{}}

  """
  def get_transaction_by_token(token) do
    case Repo.get_by(Wallets.Transaction, claim_token: token) do
      %Wallets.Transaction{} = trn ->
        {:ok, trn |> postprocess_transaction}

      nil ->
        {:error, :transaction_not_found}
    end
  end

  @doc """
  Try to determine transaction type by it's properties
  """
  def get_transaction_type(%Wallets.Transaction{claim_token: value}) when value != nil, do: :claimable
  def get_transaction_type(%Wallets.Transaction{invoice: value}) when value != nil, do: :lightning
  def get_transaction_type(%Wallets.Transaction{}), do: :other

  @doc """
  Postprocess transaction before returning it to the user

  E.g. expire claimable transactions
  """
  def postprocess_transaction(%Wallets.Transaction{} = trn) do
    postprocess_transaction(trn, get_transaction_type(trn))
  end

  def postprocess_transaction(%Wallets.Transaction{} = trn, :claimable) do
    if NaiveDateTime.compare(trn.claim_expires_at, NaiveDateTime.utc_now) != :gt do
      {:ok, trn} = update_transaction(
        trn,
        %{processed_at: trn.claim_expires_at,
          state: Wallets.Transaction.declined,
          response: "Expired"}
      )
      trn
    else
      trn
    end
  end

  def postprocess_transaction(%Wallets.Transaction{} = trn, _), do: trn

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

  def create_funding_transaction(wallet, opts \\ []) do
    attrs = %{
      wallet_id: wallet.id,
      description: Keyword.get(opts, :description, "Funding transaction"),
      msatoshi: Bitcoin.to_msatoshi(Keyword.get(opts, :amount, {"10", :mbtc})),
      state: "approved"
    }
    %Wallets.Transaction{}
    |> Wallets.Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create transaction claimable by providing claim token.

  Options:
    - amount (e.g. {1, :satoshi})
    - description - transaction description which will be visible to both payee and payer
    - expires_after - period in seconds after which it's not possible to claim transaction

  ## Examples

      iex> create_claimable_transaction(wallet, amount: {10, :satoshi}, expires_after: 86400, description: "Hello")
      %Transaction{}

  """
  def create_claimable_transaction(%Wallets.Wallet{} = wallet, opts \\ []) do
    amount = Keyword.get(opts, :amount)
    expires_after = Keyword.get(opts, :expires_after, 86400)

    with :ok <- Validation.maybe_validation_error(Bitcoin.validate_amount(amount)),
         :ok <- Validation.maybe_validation_error(Bitcoin.is_positive_amount(amount)),
         msatoshi <- Bitcoin.to_msatoshi(amount),
         {:ok, trn} <- create_transaction(%{
                  wallet_id: wallet.id,
                  description: Keyword.get(opts, :description),
                  claim_token: Ecto.UUID.generate,
                  claim_expires_at: NaiveDateTime.utc_now |> NaiveDateTime.add(expires_after, :second),
                  msatoshi: -msatoshi,
                  state: Wallets.Transaction.initial
         }),
         {:ok, _} <- enforce_sufficient_balance(wallet, trn)
      do
        case Keyword.get(opts, :to_email) do
          nil -> nil
          to_email ->
            Logger.info "Sending claim transaction email to #{to_email}"

            Wallet.Email.claim_transaction_email(to_email, "https://testwallet.biluminate.com/#/claim/#{trn.claim_token}")
            |> Wallet.Mailer.deliver_now
        end

        {:ok, trn}
      else
        {:error, %Wallet.NonSufficientFunds{transaction: declined_transaction}} ->
          {:ok, declined_transaction}
        {:error, %Wallet.ValidationError{}} = error ->
          error
        error ->
          Logger.error "Failed to create claimable transaction"
          error
    end
  end

  def claim_transaction!(%Wallets.Wallet{} = wallet, token) do
    {:ok, src_trn} = get_transaction_by_token(token)

    case Validation.expect_claimable_transaction(src_trn) do
      :ok ->
        nil

      {:error, %Wallet.ValidationError{details: details}} ->
        raise "Can't claim this transaction - #{details}"

      {:error, error} ->
        raise "Can't claim this transaction"
    end

    {:ok, %Wallets.Transaction{} = dst_trn} = Repo.transaction(
      fn ->
        case create_transaction(
              %{"wallet_id" => wallet.id,
                "state" => "approved",
                "msatoshi" => -src_trn.msatoshi,
                "src_transaction_id" => src_trn.id,
                "processed_at" => NaiveDateTime.utc_now,
                "description" => src_trn.description}) do
          {:ok, dst_trn} ->
            {:ok, _} = update_transaction(
            src_trn,
            %{processed_at: NaiveDateTime.utc_now,
              state: Wallets.Transaction.approved,
              claimed_by: dst_trn.id})
            dst_trn
          {:error, _} ->
            raise "Can't claim this transaction (already claimed?)"
        end
      end
    )

    dst_trn
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
      else err -> err
    end

  end

  @doc """
  Ensure that wallet has sufficient balance after given transaction

  Otherwise decline such transaction
  """
  def enforce_sufficient_balance(%Wallets.Wallet{} = wallet, %Wallets.Transaction{state: "initial"} = trn) do
    # Make sure that we work with up-to-date balance
    %Wallets.Wallet{balance: balance} = wallet = get_wallet!(wallet.id)

    if balance >= 0 do
      {:ok, balance}
    else
      {:ok, declined_transaction} = update_transaction(
        trn, %{processed_at: NaiveDateTime.utc_now,
               state: Wallets.Transaction.declined,
               response: "NSF"})
      {:error, Wallet.NonSufficientFunds.exception(wallet: wallet, transaction: declined_transaction)}
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
