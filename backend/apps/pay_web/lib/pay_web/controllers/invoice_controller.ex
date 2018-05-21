defmodule PayWeb.InvoiceController do
  use PayWeb, :controller

  def index(conn, %{"invoice" => [invoice|_]}) do
    redirect conn, external: "https://bit-1.biluminate.net/#/pay/#{invoice}"
  end
end
