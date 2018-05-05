defmodule WalletApiWeb.Features.PaymentTest do
  use WalletApiWeb.ConnCase

  @user1_sub "userX"

  setup %{conn: conn} do
    conn = conn
    |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  def with_auth(conn, token) do
    recycle(conn)
    |> put_req_header("authorization", "Bearer " <> token)
  end

  describe "new wallet" do
    test "is created (with funding balance) for each new user (unknown sub) who access API", %{conn: conn} do
      token1 = WalletApiWeb.Auth0.create_token(%{sub: @user1_sub})
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      assert %{"id" => _, "balance" => 510000000} = json_response(conn, 200)["data"]
    end
  end
end
