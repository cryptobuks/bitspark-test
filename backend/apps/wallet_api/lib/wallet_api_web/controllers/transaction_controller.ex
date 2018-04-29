defmodule WalletApiWeb.TransactionController do
  use WalletApiWeb, :controller

  alias WalletApi.Wallets
  alias WalletApi.Wallets.Transaction

  action_fallback WalletApiWeb.FallbackController

  @users_wallet_id "20000000-0000-0000-0000-000000000001"

  def index(conn, _params) do
    transactions = Wallets.list_transactions()
    render(conn, "index.json", transactions: transactions)
  end

  # Pay invoice
  def create(conn, %{"invoice" => invoice}) do
    with {:ok, %Transaction{} = transaction} <- Wallets.pay_invoice(
           @users_wallet_id, invoice) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def create(conn, %{"transaction" => transaction_params}) do
    with {:ok, %Transaction{} = transaction} <- Wallets.create_transaction(
           transaction_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Wallets.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end
end
