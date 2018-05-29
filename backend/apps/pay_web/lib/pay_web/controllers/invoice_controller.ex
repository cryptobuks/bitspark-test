defmodule PayWeb.InvoiceController do
  use PayWeb, :controller

  def index(conn, %{"invoice" => [invoice|_]}) do
    redirect conn, external: "https://testwallet.biluminate.com/#/pay/#{invoice}"
  end
end
