defmodule WalletWeb.TransactionController do
  require Logger
  use WalletWeb, :controller

  alias Wallet.Accounts
  alias Wallet.Wallets
  alias Wallet.Wallets.Transaction

  action_fallback WalletWeb.FallbackController

  def index(conn, _params) do
    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    transactions = Wallets.list_transactions(wallet)
    render(conn, "index.json", transactions: transactions)
  end

  # Pay invoice
  def create(conn, %{"invoice" => invoice}) do
    invoice = String.downcase(invoice)

    unless Bitcoin.is_invoice(invoice) do
      Logger.warn "Invalid invoice '#{invoice}' given."
      raise WalletWeb.InvalidInvoice, invoice: invoice
    end

    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    with {:ok, %Transaction{} = transaction} <- Wallets.pay_invoice(
           wallet.id, invoice) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  # Email transaction
  def create(conn, %{"to_email" => to_email, "msatoshi" => msatoshi, "description" => description, "expires_after" => expires_after}) do
    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    with {:ok, %Transaction{} = transaction} <- Wallets.create_claimable_transaction(
           wallet,
           to_email: to_email,
           amount: {msatoshi, :msatoshi},
           expires_after: expires_after,
           description: description
         ) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", transaction_path(conn, :show, transaction))
      |> render("show.json", transaction: transaction)
    end
  end

  # Claim transaction
  def create(conn, %{"claim_token" => claim_token}) do
    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    with {:ok, %Transaction{} = transaction} <- Wallets.claim_transaction(wallet, claim_token) do
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
