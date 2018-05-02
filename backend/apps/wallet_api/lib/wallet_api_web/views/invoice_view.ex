defmodule WalletApiWeb.InvoiceView do
  use WalletApiWeb, :view
  alias WalletApiWeb.InvoiceView

  def render("show.json", %{invoice: invoice}) do
    %{data: render_one(invoice, InvoiceView, "invoice.json")}
  end

  def render("invoice.json", %{invoice: invoice}) do
    %{
      description: invoice.description,
      msatoshi: invoice.msatoshi
    }
  end
end
