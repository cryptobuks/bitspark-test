defmodule Wallet.Schema.Wallets do
  @moduledoc false
  use Absinthe.Schema.Notation

  require Logger
  alias Wallet.Accounts
  alias Wallet.Wallets

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

    @desc "Find particular wallet transaction by id."
    field :transaction, :transaction do
      arg :id, non_null(:id)

      resolve &find_transaction/3
    end
  end

  ## Resolvers
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

  def find_transaction(wallet, %{id: id}, _info) do
    try do
      transaction = Wallets.get_transaction!(wallet, id)
      {:ok, transaction}
    rescue
      _ -> {:error, "Not found"}
    end
  end

  def find_transactions(wallet, _args, _info) do
    transactions = Wallets.list_transactions(wallet)
    {:ok, transactions}
  end
end
