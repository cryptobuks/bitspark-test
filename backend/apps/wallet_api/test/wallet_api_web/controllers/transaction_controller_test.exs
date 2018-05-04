defmodule WalletApiWeb.TransactionControllerTest do
  import AssertValue
  use WalletApiWeb.ConnCase

  alias WalletApi.Accounts
  alias WalletApi.Wallets

  @create_attrs %{
    state: "initial",
    description: "some description",
    invoice: "some invoice",
    msatoshi: 2100000000000000000}
  @invalid_attrs %{description: nil, invoice: nil, msatoshi: nil}

  def fixture(:wallet) do
    {:ok, user} = Accounts.create_user(%{sub: "xyz"})
    {:ok, wallet} = Wallets.create_wallet(%{user_id: user.id})
    wallet
  end

  def fixture(:token) do
    WalletApiWeb.Auth0.create_token(%{})
  end

  def with_auth(token, conn) do
    conn |> put_req_header("authorization", "Bearer " <> token)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      token = fixture(:token)
      conn = get with_auth(token, conn), transaction_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      token = fixture(:token)
      wallet = fixture(:wallet)

      # Create
      conn = with_auth(token, recycle(conn))
      conn = post with_auth(token, conn), transaction_path(conn, :create),
        transaction: Enum.into(%{wallet_id: wallet.id}, @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      # Show
      conn = with_auth(token, recycle(conn))
      conn = get conn, transaction_path(conn, :show, id)
      assert_value json_response(conn, 200)["data"] == %{
        "description" => "some description",
        "id" => id,
        "invoice" => "some invoice",
        "msatoshi" => 2100000000000000000,
        "state" => "initial"
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      token = fixture(:token)
      conn = post with_auth(token, conn), transaction_path(conn, :create), transaction: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
