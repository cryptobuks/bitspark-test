defmodule Wallet.Wallets.Schema do
  use Absinthe.Schema
  require Logger

  alias Wallet.Accounts
  alias Wallet.Wallets

  object :wallet_balance do
    field :msatoshi, :integer
  end

  object :wallet do
    field :id, non_null(:id)
    field :balance, non_null(:wallet_balance), resolve: &get_wallet_balance/3
    field :transactions, list_of(:transaction), resolve: &find_transactions/3
  end

  object :transaction do
    field :id, non_null(:id)
    field :state, non_null(:string)
    field :msatoshi, non_null(:integer)
  end

  query do
    field :current_user_wallet, non_null(:wallet) do
      resolve &get_wallet/3
    end
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