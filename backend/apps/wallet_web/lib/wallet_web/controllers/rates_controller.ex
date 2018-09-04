defmodule WalletWeb.RatesController do
  use WalletWeb, :controller

  action_fallback WalletWeb.FallbackController

  def show(conn, %{"currency" => "BTC"}) do
    render(conn, "show.json", rates: Wallet.CurrencyRates.get_rates("BTC"))
  end
end
