defmodule WalletWeb.Features.PaymentTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  import ExUnit.CaptureLog
  require Logger

  use WalletWeb.ConnCase

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
      token1 = WalletWeb.Auth0.create_token(%{sub: @user1_sub})
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      assert_value canonicalize(json_response(conn, 200)["data"]) == %{"balance" => %{"msatoshi" => 510000000}, "id" => "<UUID>"}
    end
  end

  describe "successful transaction" do
    test "updates wallet balance", %{conn: conn} do
      token1 = WalletWeb.Auth0.create_token(%{sub: @user1_sub})

      # wallet before
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_before = json_response(conn, 200)["data"]

      # pay invoice
      invoice = "lntb500u...200"
      conn = post with_auth(conn, token1), transaction_path(conn, :create),
        invoice: invoice
      json_response(conn, 201)

      # wallet after
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_after = json_response(conn, 200)["data"]

      assert_value [before: wallet_before["balance"], after: wallet_after["balance"]] == [before: %{"msatoshi" => 510000000}, after: %{"msatoshi" => 460000000}]
    end
  end

  describe "failed transaction" do
    test "keeps original wallet balance", %{conn: conn} do
      token1 = WalletWeb.Auth0.create_token(%{sub: @user1_sub})

      # wallet before
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_before = json_response(conn, 200)["data"]

      # pay invoice
      log = capture_log(fn ->
        invoice = "lntb500u...999"
        conn = post with_auth(conn, token1), transaction_path(conn, :create),
        invoice: invoice
        json_response(conn, 201)["data"]
      end)

      assert log =~ "UnknownPaymentHash"

      # wallet after
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_after = json_response(conn, 200)["data"]

      assert wallet_after["balance"] == wallet_before["balance"]
    end
  end

  describe "non-sufficient funds" do
    test "results in declined transaction", %{conn: conn} do
      token1 = WalletWeb.Auth0.create_token(%{sub: @user1_sub})

      # wallet before
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_before = json_response(conn, 200)["data"]

      assert_value wallet_before["balance"] == %{"msatoshi" => 510000000}

      # try to pay invoice -> declined
      invoice = "lntb6m...200" # 6 mBTC
      conn = post with_auth(conn, token1), transaction_path(conn, :create),
        invoice: invoice
      assert_value Map.take(json_response(conn, 201)["data"], ["state"]) == %{"state" => "declined"}

      # wallet after
      conn = get with_auth(conn, token1), wallet_path(conn, :show)
      wallet_after = json_response(conn, 200)["data"]

      assert_value [before: wallet_before["balance"], after: wallet_after["balance"]] == [before: %{"msatoshi" => 510000000}, after: %{"msatoshi" => 510000000}]
    end
  end
end
