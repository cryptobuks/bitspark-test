defmodule PayWeb.BaguetteInvoiceController do
  use PayWeb, :controller

  def index(conn, _params) do
    invoice = Pay.Canteen.create_invoice(:baguette)

    conn =
      conn
      |> put_resp_header("lightning-invoice", invoice)
    redirect conn, external: "https://bit-1.biluminate.net/#/pay/#{invoice}"
  end
end
