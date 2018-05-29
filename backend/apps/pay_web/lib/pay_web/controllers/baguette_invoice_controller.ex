defmodule PayWeb.BaguetteInvoiceController do
  use PayWeb, :controller

  def index(conn, _params) do
    {:ok, invoice} = Canteen.create_invoice(:baguette)

    conn =
      conn
      |> put_resp_header("lightning-invoice", invoice)
    redirect conn, external: "https://testwallet.biluminate.com/#/pay/#{invoice}"
  end
end
