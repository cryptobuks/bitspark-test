defmodule WalletApiWeb.InvoiceController do
  use WalletApiWeb, :controller

  alias WalletApi.Lightning

  action_fallback WalletApiWeb.FallbackController

  def show(conn, %{"id" => id}) do
    {:ok, payload} = Lightning.decode_invoice(id)
    render(conn, "show.json", invoice: payload)
  end
end
