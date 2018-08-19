defmodule WalletWeb.TransactionControllerTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  use WalletWeb.ConnCase

  alias Wallet.Accounts
  alias Wallet.Wallets

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  def with_user(conn, sub \\ "userX") do
    token = WalletWeb.Auth0.create_token(%{sub: sub})
    {:ok, _user} = Accounts.create_user(%{sub: sub})

    recycle(conn)
    |> put_req_header("authorization", "Bearer " <> token)
  end

  describe "claimable transaction" do
    test "can be created & claimed", %{conn: conn} do
      # Create
      conn = post with_user(conn, "src"), transaction_path(conn, :create),
        [to_email: "a@b.cz", msatoshi: 1000, description: "Hello", expires_after: 60]

      created = json_response(conn, 201)["data"]
      assert_value canonicalize(created) == %{
                     "claim_expires_at" => "<TIMESTAMP>",
                     "description" => "Hello",
                     "id" => "<UUID>",
                     "inserted_at" => "<TIMESTAMP>",
                     "msatoshi" => -1000,
                     "processed_at" => nil,
                     "state" => "initial"
                   }

      # Claim
      src_trn = Wallets.get_transaction!(created["id"])
      conn = post with_user(conn, "dst"), transaction_path(conn, :create),
        [claim_token: src_trn.claim_token]

      claimed = json_response(conn, 201)["data"]
      assert_value canonicalize(claimed) == %{
                     "description" => "Hello",
                     "id" => "<UUID>",
                     "inserted_at" => "<TIMESTAMP>",
                     "msatoshi" => 1000,
                     "processed_at" => "<TIMESTAMP>",
                     "state" => "approved"
                   }
    end
  end
end
