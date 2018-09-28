defmodule Wallet.Schema do
  use Absinthe.Schema
  require Logger

  alias Wallet.Accounts
  alias Wallet.Wallets

  import_types Absinthe.Type.Custom
  import_types Wallet.Schema.Scalars
  import_types Wallet.Schema.Enums

  object :wallet_balance do
    @desc "Amount in milli-satoshi (0.001 satoshi)."
    field :msatoshi, :msatoshi
  end

  object :wallet do
    field :id, non_null(:id)
    @desc """
    Spendable balance

    - Includes pending outgoing transactions (e.g., non-claimed email transactions)
    - Doesn't include pending incomming transactions (e.g., unconfirmed on-chain transactions)
    """
    field :balance, non_null(:wallet_balance), resolve: &get_wallet_balance/3
    @desc "List of transactions associated with the wallet."
    field :transactions, list_of(:transaction), resolve: &find_transactions/3
  end

  interface :transaction do
    field :id, non_null(:id)
    @desc "Transaction processing state."
    field :state, non_null(:transaction_state)
    @desc "Transaction amount."
    field :msatoshi, non_null(:msatoshi)
    @desc "Human readable description (e.g., purchased item description)."
    field :description, non_null(:string)

    resolve_type &transaction_type_resolver/2
  end

  def transaction_type_resolver(%Wallet.Wallets.Transaction{} = trn, _) do
    case trn do
      %{description: "Funding transaction"} -> :funding_transaction
      %{invoice: "" <> _} -> :lightning_transaction
      %{to_email: "" <> _} -> :to_email_transaction
      _ -> :other_transaction
    end
  end

  object :base_transaction do
    field :id, non_null(:id)
    field :state, non_null(:transaction_state),
      resolve: fn %Wallet.Wallets.Transaction{state: state}, _, _ -> {:ok, String.to_atom(state)} end
    field :msatoshi, non_null(:msatoshi)
    field :description, non_null(:string)
  end

  object :funding_transaction do
    import_fields :base_transaction
    interface :transaction
  end

  object :lightning_transaction do
    import_fields :base_transaction
    @desc "Lightning invoice (e.g., lntb32u1p...4qax)."
    field :invoice, non_null(:string)
    interface :transaction
  end

  object :to_email_transaction do
    import_fields :base_transaction
    @desc "Email of payee who will receive instructions how to claim this transaction."
    field :to_email, non_null(:string)
    @desc "Date after which payee will be no longer able to claim the transaction."
    field :claim_expires_at, non_null(:naive_datetime)

    interface :transaction
  end

  object :other_transaction do
    import_fields :base_transaction
    interface :transaction
  end

  query do
    @desc """
    Wallet of currently authenticated user (via JWT token).
    """
    field :current_user_wallet, non_null(:wallet) do
      resolve &get_wallet/3
    end
  end

  @desc "The payload for lightning transaction processing."
  object :process_lightning_transaction_payload do
    @desc "Processed transaction."
    field :transaction, non_null(:lightning_transaction)
  end

  @desc "The input for lightning transaction processing."
  input_object :process_lightning_transaction_input do
    field :invoice, non_null(:string)
  end

  mutation do
    @desc "Process lightning transaction."
    field :process_lightning_transaction, type: :process_lightning_transaction_payload do
      arg :input, non_null(:process_lightning_transaction_input)

      resolve &Wallet.Schema.LightningTransactions.process_lightning_transaction/2
    end
  end

  subscription do
    @desc """
    Returns updated Wallet object when wallet is somehow modified (e.g., new transaction is created).
    """
    field :current_user_wallet_updated, :wallet do
      config fn _, %{context: context} ->
        wallet = context.assigns.joken_claims["sub"]
        |> Accounts.login!
        |> Wallets.get_or_create_wallet!

        {:ok, topic: wallet.id}
      end

      resolve &get_wallet/3
    end
  end

  def get_wallet(%Wallets.Transaction{wallet_id: wallet_id}, _args, _context) do
    wallet = Wallets.get_wallet!(wallet_id)
    {:ok, wallet}
  end

  def get_wallet(_root, _args, %{context: context}) do
    account = Accounts.login!(context.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(account)
    {:ok, wallet}
  end

  def get_wallet_balance(wallet, _args, _info) do
    balance = Wallets.get_wallet_balance(wallet)
    {:ok, %{msatoshi: balance}}
  end

  def find_transactions(wallet, _args, _info) do
    transactions = Wallets.list_transactions(wallet)
    {:ok, transactions}
  end
end
