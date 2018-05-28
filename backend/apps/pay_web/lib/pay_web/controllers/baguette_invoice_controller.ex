defmodule PayWeb.BaguetteInvoiceController do
  use PayWeb, :controller

  def index(conn, _params) do
    invoice = "lntb1500n1pdscxv9pp5khljzedum3rlj9l07axd360hkwpvwrtvyejyhwakgwmwx4eyxemqdpa2fjkzep6yptksct5ypc8ymmzd3jk6ueqv3hjq7t0w5sxsctkv5s8w6r9dcs8qcqzysqhsjze7ze8pers05g65jptqzepekv0cc4eafky43eskgu9n3qw2kxefh8qfr5yfd2gtx5fycwmvex39jy8rj9y6m2ana7pewggr653sq0zvxyq"
    conn =
      conn
      |> put_resp_header("lightning-invoice", invoice)
    redirect conn, external: "https://bit-1.biluminate.net/#/pay/#{invoice}"
  end
end
