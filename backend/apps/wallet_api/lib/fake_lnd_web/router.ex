defmodule FakeLndWeb.Router do
  use Plug.Router
  import Plug.Conn

  plug :auth
  plug :match
  plug :dispatch

  get "/v1/payreq/:invoice" do
    num_satoshis = Bitcoin.invoice_satoshi(invoice)

    payload = %{
      "cltv_expiry" => "144",
      "description" => "Foobar #" <> String.slice(invoice, -3, 3),
      "destination" => "039cc950286a8fa99218283d1adc2456e0d5e81be558da77dd6e85ba9a1fff5ad3",
      "expiry" => "3600",
      "num_satoshis" => "#{num_satoshis}",
      "payment_hash" => "4ce6edd6cddecfd12b6114900dcc5442e35415a4136091d79b7250cd05747600",
      "timestamp" => to_string(Joken.current_time - 60)
    }

    conn
    |> json(200, payload)
  end

  post "/v1/channels/transactions" do
    invoice = conn.body_params["payment_request"]
    total_amt = Bitcoin.invoice_satoshi(invoice)
    fee = 1

    case String.slice(invoice, -3, 3) do
      "999" -> json(conn, 200, %{payment_error: "UnknownPaymentHash"})
      _ -> result = Poison.decode!("""
            {
              "payment_preimage": "+b9n1eSD0DlPhIdh8JowwMhQfJXEAsxV6RAspa4OJRA=",
              "payment_route": {
                "total_time_lock": 1292308,
                "total_fees": "#{fee}",
                "total_amt": "#{total_amt + fee}",
                "hops": [
                  {
                    "chan_id": "1420515147023712256",
                    "chan_capacity": "897123",
                    "amt_to_forward": "#{total_amt}",
                    "fee": "#{fee}",
                    "expiry": 1292164
                  },
                  {
                    "chan_id": "1417756472375115776",
                    "chan_capacity": "1000000",
                    "amt_to_forward": "100",
                    "expiry": 1292164
                  }
                ]
              }
            }
          """)

        conn
        |> json(200, result)
    end
  end

  def auth(conn, _opts) do
    case get_req_header(conn, "grpc-metadata-macaroon") do
      ["foobar"] -> conn
      _ -> conn |> json(500, %{
            "error" => "verification failed: signature mismatch after caveat verification",
            "code" => 2})
    end
  end

  def json(conn, status, x) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(x))
  end
end
