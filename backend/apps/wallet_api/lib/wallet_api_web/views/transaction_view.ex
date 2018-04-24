defmodule WalletApiWeb.TransactionView do
  use WalletApiWeb, :view
  alias WalletApiWeb.TransactionView

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
      msatoshi: transaction.msatoshi,
      invoice: transaction.invoice}
  end
end
