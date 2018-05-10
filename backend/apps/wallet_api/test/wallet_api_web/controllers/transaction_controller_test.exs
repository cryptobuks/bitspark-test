defmodule WalletApiWeb.TransactionControllerTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
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
    WalletApiWeb.Auth0.create_token()
  end

  def with_auth(token, conn) do
    conn |> put_req_header("authorization", "Bearer " <> token)
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions (new wallet contains funding transaction only)", %{conn: conn} do
      token = fixture(:token)
      conn = get with_auth(token, conn), transaction_path(conn, :index)
      data = json_response(conn, 200)["data"]
      assert_value canonicalize(data) == [%{"description" => "Funding transaction", "id" => "<UUID>", "inserted_at" => "<TIMESTAMP>", "invoice" => nil, "msatoshi" => 510000000, "processed_at" => nil, "state" => "approved"}]
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
      data = json_response(conn, 200)["data"]
      assert_value Map.take(data, ["id", "msatoshi", "state", "invoice", "description"]) == %{
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
