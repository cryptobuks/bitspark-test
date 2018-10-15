defmodule Wallet.Wallets do
  @moduledoc """
  The Wallets context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias Wallet.Repo

  alias Lightning
  alias Wallet.Wallets
  alias Wallet.Events
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

  def get_transaction!(%Wallets.Wallet{} = wallet, id) do
    Repo.one!(
      from(
        t in Wallets.Transaction,
        select: t,
        where: t.id == ^id and t.wallet_id == ^wallet.id
      )
    )
  end

  @doc """
  Gets a single transaction with "FOR UPDATE" lock.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.
  """
  def get_transaction_for_update!(id) do
    Repo.one!(
      from(
        t in Wallets.Transaction,
        select: t,
        where: t.id == ^id,
        lock: "FOR UPDATE"
      )
    )
  end

  @doc """
  Gets a transaction associated with given on-chain txid.

  ## Example

      iex> get_transaction_by_on_chain_txid("92633f69aacfd7595baa923243f249e0f36db52e45ae67e6571b6661df2b6745")
      {:ok, %Transaction{}}

  """
  def get_transaction_by_on_chain_txid(on_chain_txid) do
    case Repo.get_by(Wallets.Transaction, on_chain_txid: on_chain_txid) do
      %Wallets.Transaction{} = trn ->
        {:ok, trn}

      nil ->
        {:error, :transaction_not_found}
    end
  end

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

  # Postprocess transaction before returning it to the user
  # E.g. expire claimable transactions
  defp postprocess_transaction(%Wallets.Transaction{} = trn) do
    postprocess_transaction(trn, Wallets.Transaction.get_transaction_type(trn))
  end

  # Expire initial/pending claimable transactions
  defp postprocess_transaction(%Wallets.Transaction{state: "initial"} = trn, :claimable) do
    if Wallets.Transaction.should_claimable_transaction_expire(trn) do
      case expire_claimable_transaction(trn) do
        {:ok, expired_trn} -> expired_trn
        {:error, _error} ->
          # Postprocessing isn't (that) critical, so let's not fail here. Just
          # log warning, and return original transaction.
          Logger.warn "Failed to postprocess (expire) transaction trn_id=#{trn.id}"
          trn
      end
    else
      trn
    end
  end

  defp postprocess_transaction(%Wallets.Transaction{} = trn, _), do: trn

  # Safely expire given claimable transaction
  defp expire_claimable_transaction(%Wallets.Transaction{} = trn) do
    Repo.transaction(fn ->
      trn = get_transaction_for_update!(trn.id)

      # Make sure that transaction is still ready to be expired
      if Wallets.Transaction.should_claimable_transaction_expire(trn) do
        {:ok, trn} = update_transaction(trn, %{processed_at: trn.claim_expires_at,
                                               state: Wallets.Transaction.declined,
                                               response: "Expired"})
        trn
      else
        trn
      end
    end)
  end

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
    |> on_success(&Events.transaction_created/1)
  end

  def create_funding_transaction(wallet, opts \\ []) do
    attrs = %{
      wallet_id: wallet.id,
      description: Keyword.get(opts, :description, "Funding transaction"),
      msatoshi: Bitcoin.Amount.to_msatoshi(Keyword.get(opts, :amount, {"10", :mbtc})),
      state: "approved"
    }

    with {:ok, initial} <- create_transaction(attrs),
         {:ok, processed} <- update_transaction(initial, %{processed_at: TestableNaiveDateTime.utc_now})
      do
      {:ok, processed}
    end
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

    with :ok <- Validation.maybe_validation_error(Bitcoin.Amount.validate(amount)),
         :ok <- Validation.maybe_validation_error(Bitcoin.Amount.is_positive(amount)),
         msatoshi <- Bitcoin.Amount.to_msatoshi(amount),
         {:ok, trn} <- create_transaction(%{
                  wallet_id: wallet.id,
                  description: Keyword.get(opts, :description),
                  to_email: Keyword.get(opts, :to_email),
                  claim_token: Ecto.UUID.generate,
                  claim_expires_at: TestableNaiveDateTime.utc_now |> NaiveDateTime.add(expires_after, :second),
                  msatoshi: -msatoshi,
                  state: Wallets.Transaction.initial
         }),
         {:ok, _} <- enforce_sufficient_balance(wallet, trn)
      do
        case Keyword.get(opts, :to_email) do
          nil -> nil
          to_email ->
            Logger.info "Sending claim transaction email to #{to_email}"

            Wallet.Email.claim_transaction_email(to_email, trn.claim_token)
            |> Wallet.Mailer.deliver_now
        end

        Task.start(fn ->
          # Poor man's expiration triggering :) (Doesn't survive server restart)
          :timer.sleep(:timer.seconds(expires_after + 1))
          get_transaction!(trn.id)
        end)

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

  @doc """
  Claim given transaction (by token)

  Call is idempotent, and returns existing transaction if transaction has
  already been claimed by same wallet.

  ## Examples

    iex> claim_transaction("373e4ceb-e305-49ee-bc40-ddf6cb9e73c1")
    {:ok, %Transaction{}}

  """
  def claim_transaction(%Wallets.Wallet{} = wallet, token) when is_bitstring(token) do
    {:ok, result} = Repo.transaction(fn ->
      with {:ok, src_trn_by_token} <- get_transaction_by_token(token) do
        claim_transaction(wallet, get_transaction_for_update!(src_trn_by_token.id))
      end
    end)

    result
  end

  # Handle already claimed state
  def claim_transaction(%Wallets.Wallet{} = wallet, %Wallets.Transaction{claimed_by: claimed_by} = src_trn) when claimed_by != nil do
    dst_trn = get_transaction!(claimed_by)

    if wallet.id == dst_trn.wallet_id do
      # Same wallet already claimed this transaction so just return original one
      {:ok, dst_trn}
    else
      # Should fail with already claimed error
      Validation.expect_claimable_transaction(src_trn)
    end
  end

  # Try to claim the transaction
  def claim_transaction(%Wallets.Wallet{} = wallet, %Wallets.Transaction{} = src_trn) do
    with :ok <- Validation.expect_claimable_transaction(src_trn),
         {:ok, dst_trn} <- create_transaction(%{"wallet_id" => wallet.id,
                              "state" => "approved",
                              "msatoshi" => -src_trn.msatoshi,
                              "src_transaction_id" => src_trn.id,
                              "processed_at" => TestableNaiveDateTime.utc_now,
                              "description" => src_trn.description}) do
      # Mark source transaction as claimed
      {:ok, _} = update_transaction(src_trn, %{processed_at: TestableNaiveDateTime.utc_now,
                                               state: Wallets.Transaction.approved,
                                               claimed_by: dst_trn.id})
      {:ok, dst_trn}
    end
  end

  @doc """
  Pay lightning invoice.

  ## Examples

      iex> pay_invoice(invoice)
      {:ok, %Transaction{}}

      iex> pay_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def pay_invoice(wallet_id, invoice) do
    with {:ok, payload} <- Bitcoin.Lightning.decode_invoice(Wallet.lightning_config, invoice),
         # initial
         {:ok, trn} <- create_transaction(%{"wallet_id" => wallet_id,
                                            "invoice" => invoice,
                                            "state" => "initial",
                                            "msatoshi" => -payload.msatoshi,
                                            "description" => payload.description}),
         # check balance
         %{balance: balance} <- get_wallet!(wallet_id) do
      # process
      update = if balance < 0 do
        Logger.info "Failed to process transaction [#{trn.id}]. " <>
          "Error: Non-sufficient funds"
        %{state: Wallets.Transaction.declined, response: "NSF"}
      else
        case Bitcoin.Lightning.pay_invoice(Wallet.lightning_config, invoice) do
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
                    %{processed_at: TestableNaiveDateTime.utc_now,
                      response: Poison.encode!(update.response)},
                    update)) do
        Wallet.Log.processed_transaction(processed_transaction)
        {:ok, processed_transaction}
      end
    end
  end

  @doc """
  Create new address for incomming on-chain payments and assign it to given wallet.
  """
  def create_on_chain_address(%Wallets.Wallet{} = wallet) do
    {:ok, address} = Gold.getnewaddress(:wallet_btcd)

    %{
      address: address,
      wallet_id: wallet.id
    }
    |> create_on_chain_address
  end

  def create_on_chain_address(attrs) do
    %Wallets.OnChainAddress{}
    |> Wallets.OnChainAddress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Synchronize wallet with bitcoind state (on-chain transactions).

  Updates existing transactions and/or creates new ones.
  """
  def synchronize_on_chain_transactions() do
    # For testing purposes synchronize only last 5 transactions
    last_n_transactions = 5
    # http://chainquery.com/bitcoin-api/listtransactions
    # Sorted from oldest to newest
    {:ok, btcd_transactions} = Gold.listtransactions(:wallet_btcd, "", last_n_transactions)

    btcd_transactions
    |> Enum.filter(&(&1.category == :receive))
    |> Enum.each(&synchronize_on_chain_transaction/1)
  end

  def synchronize_on_chain_transaction(%Gold.Transaction{} = on_chain_trn) do
    IO.puts "Synchronizing incomming on-chain transaction for address #{on_chain_trn.address} - txid: #{on_chain_trn.txid}, amount: #{on_chain_trn.amount}, confirmations: #{on_chain_trn.confirmations}"
    # SELECT FOR UPDATE WHERE trn.on_chain_txid === on_chain_trn.txid
    # Update
    #   on_chain_confirmations = on_chain_trn.confirmations
    #   (when on_chain_trn.confirmations === 6 && trn.processed_at IS NULL) trn.processed_at = now()
  end

  @doc """
  Send on-chain payment to given address.
  """
  def pay_to_on_chain_address(%Wallets.Wallet{} = _wallet, address, msatoshi) do
    amount = Bitcoin.Amount.to_btc({msatoshi, :msatoshi})
    # TODO: Set transaction fee
    # TODO: - What's the amount here?
    # TODO: - Make sure that settxfee is executed in 'transaction' with sendtoaddress.
    # Gold.call(:wallet_btcd, {:settxfee, [Decimal.new("0.001")]})
    {:ok, _on_chain_txid} = Gold.sendtoaddress(:wallet_btcd, address, amount)
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
        trn, %{processed_at: TestableNaiveDateTime.utc_now,
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
    |> on_success(&Events.transaction_updated/1)
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

  defp on_success({:ok, data} = result, fun) do
    fun.(data)
    result
  end

  defp on_success(result, _fun), do: result
end
