defmodule FakeLndWeb.Router do
  use Plug.Router
  import Plug.Conn

  plug :auth
  plug :match
  plug :dispatch

  get "/v1/payreq/:invoice" do
    payload = %{
      "cltv_expiry" => "144",
      "description" => "Foobar #" <> String.slice(invoice, -3, 3),
      "destination" => "039cc950286a8fa99218283d1adc2456e0d5e81be558da77dd6e85ba9a1fff5ad3",
      "expiry" => "3600",
      "num_satoshis" => "150",
      "payment_hash" => "4ce6edd6cddecfd12b6114900dcc5442e35415a4136091d79b7250cd05747600",
      "timestamp" => to_string(Joken.current_time - 60)
    }

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(payload))
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
    conn |> send_resp(status, Poison.encode!(x))
  end
end
