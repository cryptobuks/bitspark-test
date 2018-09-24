defmodule Wallet.Schema do
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
    field :wallet, non_null(:wallet), resolve: &get_wallet/3
  end

  query do
    field :current_user_wallet, non_null(:wallet) do
      resolve &get_wallet/3
    end
  end

  subscription do
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
