defmodule Wallet.CurrencyRates.Coinbase do
  @moduledoc """
  Coinbase API client.

  Documentation: https://developers.coinbase.com/api/v2
  """

  @config Application.get_env(:wallet, Wallet.CurrencyRates.Coinbase)

  use Tesla
  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Timeout, timeout: 10_000 #ms
  plug Tesla.Middleware.Logger
  plug Tesla.Middleware.BaseUrl, Keyword.get(@config, :base_url)

  def get_rates(currency = "BTC") do
    with {:ok, response} <- get("/v2/exchange-rates?currency=#{currency}")
      do
      body = response.body
      body["data"]
    end
  end
end
