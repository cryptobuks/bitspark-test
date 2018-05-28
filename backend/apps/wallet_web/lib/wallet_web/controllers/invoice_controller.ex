defmodule WalletWeb.InvoiceController do
  use WalletWeb, :controller

  action_fallback WalletWeb.FallbackController

  def show(conn, %{"id" => id}) do
    id = String.downcase(id)

    {:ok, payload} = Lightning.decode_invoice(Application.get_env(:wallet, Lightning), id)
    render(conn, "show.json", invoice: payload)
  end
end
