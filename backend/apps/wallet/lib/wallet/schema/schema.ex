defmodule Wallet.Schema do
  use Absinthe.Schema
  require Logger

  alias Wallet.Accounts
  alias Wallet.Wallets

  import_types Absinthe.Type.Custom
  import_types Wallet.Schema.Scalars

  object :wallet_balance do
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
    field :transactions, list_of(:transaction), resolve: &find_transactions/3
  end

  interface :transaction do
    field :id, non_null(:id)
    field :state, non_null(:string)
    @desc "Transaction amount"
    field :msatoshi, non_null(:msatoshi)
    @desc "Human readable description (e.g., purchased item description)"
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
    field :state, non_null(:string)
    field :msatoshi, non_null(:msatoshi)
    field :description, non_null(:string)
  end

  object :funding_transaction do
    import_fields :base_transaction
    interface :transaction
  end

  object :lightning_transaction do
    import_fields :base_transaction
    field :invoice, non_null(:string)
    interface :transaction
  end

  object :to_email_transaction do
    import_fields :base_transaction
    field :to_email, non_null(:string)
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
