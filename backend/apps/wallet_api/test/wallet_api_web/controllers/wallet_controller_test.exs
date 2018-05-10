defmodule WalletApiWeb.WalletControllerTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  use WalletApiWeb.ConnCase

  alias WalletApi.Accounts

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  def with_user(conn) do
    sub = "userX"
    token = WalletApiWeb.Auth0.create_token(%{sub: sub})
    {:ok, _user} = Accounts.create_user(%{sub: sub})

    conn
    |> put_req_header("authorization", "Bearer " <> token)
  end

  describe "show" do
    test "returns basic wallet info", %{conn: conn} do
      conn = get with_user(conn), wallet_path(conn, :show)
      assert_value canonicalize(json_response(conn, 200)["data"]) == %{"balance" => %{"msatoshi" => 510000000}, "id" => "<UUID>"}
    end
  end
end
