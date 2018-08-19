defmodule WalletWeb.TransactionControllerTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  use WalletWeb.ConnCase

  alias Wallet.Accounts

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  def with_user(conn) do
    sub = "userX"
    token = WalletWeb.Auth0.create_token(%{sub: sub})
    {:ok, _user} = Accounts.create_user(%{sub: sub})

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end

  describe "claimable transaction" do
    test "can be created", %{conn: conn} do
      conn = post with_user(conn), transaction_path(conn, :create),
        [to_email: "a@b.cz", msatoshi: 1000, description: "Hello", expires_after: 60]

      assert_value canonicalize(json_response(conn, 201)["data"]) == %{
                     "claim_expires_at" => "<TIMESTAMP>",
                     "description" => "Hello",
                     "id" => "<UUID>",
                     "inserted_at" => "<TIMESTAMP>",
                     "msatoshi" => -1000,
                     "processed_at" => nil,
                     "state" => "initial"
                   }
    end
  end
end
