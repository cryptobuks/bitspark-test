defmodule PayWeb.InvoiceController do
  use PayWeb, :controller

  def wallet_url(path) do
    base = Application.get_env(:pay_web, PayWeb.InvoiceController)
    |> Keyword.get(:wallet_base_url)
    "#{base}#{path}"
  end

  def index(conn, %{"invoice" => [invoice|_]}) do
    redirect conn, external: wallet_url("/#/pay/#{invoice}")
  end

  def piccolo(conn, _params) do
    {:ok, invoice} = Canteen.create_invoice(:piccolo)

    conn =
      conn
      |> put_resp_header("lightning-invoice", invoice)
    redirect conn, external: wallet_url("/#/pay/#{invoice}")
  end

  def baguette(conn, _params) do
    {:ok, invoice} = Canteen.create_invoice(:baguette)

    conn =
      conn
      |> put_resp_header("lightning-invoice", invoice)
    redirect conn, external: wallet_url("/#/pay/#{invoice}")
  end
end
