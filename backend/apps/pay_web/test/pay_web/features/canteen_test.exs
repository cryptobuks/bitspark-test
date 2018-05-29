defmodule Pay.Features.PaymentTest do
  import AssertValue
  import Utils, only: [canonicalize: 1]
  use PayWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  describe "GET/HEAD /baguette" do
    test "generates invoice", %{conn: conn} do
      conn = head conn, "/baguette"

      assert_value canonicalize(get_resp_header(conn, "lightning-invoice")) == ["<INVOICE>"]
      assert_value canonicalize(get_resp_header(conn, "location")) == ["https://testwallet.biluminate.com/#/pay/<INVOICE>"]
    end
  end
end
