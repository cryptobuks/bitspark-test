defmodule WalletWeb.InvoiceController do
  use WalletWeb, :controller

  alias Wallet.Lightning

  action_fallback WalletWeb.FallbackController

  def show(conn, %{"id" => id}) do
    id = String.downcase(id)

    {:ok, payload} = Lightning.decode_invoice(id)
    render(conn, "show.json", invoice: payload)
  end
end
