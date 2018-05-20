defmodule WalletWeb.TransactionView do
  use WalletWeb, :view
  alias WalletWeb.TransactionView

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      description: transaction.description,
      state: transaction.state,
      inserted_at: transaction.inserted_at,
      processed_at: transaction.processed_at,
      msatoshi: transaction.msatoshi,
      invoice: transaction.invoice}
  end
end
