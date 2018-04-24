defmodule WalletApiWeb.TransactionControllerTest do
  use WalletApiWeb.ConnCase

  alias WalletApi.Accounts
  alias WalletApi.Wallets

  @create_attrs %{state: "initial", description: "some description", invoice: "some invoice",
                  msatoshi: 2100000000000000000}
  @invalid_attrs %{description: nil, invoice: nil, msatoshi: nil}

  def fixture(:wallet) do
    {:ok, user} = Accounts.create_user(%{sub: "xyz"})
    {:ok, wallet} = Wallets.create_wallet(%{user_id: user.id})
    wallet
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get conn, transaction_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders transaction when data is valid", %{conn: conn} do
      wallet = fixture(:wallet)
      conn = post conn, transaction_path(conn, :create),
        transaction: Enum.into(%{wallet_id: wallet.id}, @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, transaction_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "state" => "initial",
        "description" => "some description",
        "invoice" => "some invoice",
        "msatoshi" => 2100000000000000000}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, transaction_path(conn, :create), transaction: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
