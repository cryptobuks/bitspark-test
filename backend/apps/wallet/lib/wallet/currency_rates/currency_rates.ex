defmodule Wallet.CurrencyRates do
  use Agent
  alias Wallet.CurrencyRates.Coinbase

  @ttl :timer.seconds(60)
  @max_client_wait_time :timer.seconds(2)

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get_cache(currency) do
    Agent.get(__MODULE__, &Map.fetch(&1, currency))
  end

  def set_cache(currency, rates) do
    Agent.update(__MODULE__, &Map.put(
          &1, currency, %{rates: rates, updated_at: NaiveDateTime.utc_now}))
    rates
  end

  def get_rates(currency = "BTC") do
    case get_cache(currency) do
      {:ok, %{rates: cached_rates, updated_at: updated_at}} ->
        if NaiveDateTime.diff(NaiveDateTime.utc_now, updated_at, :millisecond) > @ttl do
          refresh = Task.async(fn -> force_get_rates(currency) end)
          # We don't want client to wait for too long so we better return cached
          # values even if they are old(er).
          case Task.yield(refresh, @max_client_wait_time) do
            {:ok, rates} -> rates
            nil ->
              cached_rates
          end
        else
          cached_rates
        end
      :error ->
        force_get_rates(currency)
    end
  end

  defp force_get_rates(currency) do
    fresh_rates = Coinbase.get_rates(currency)
    set_cache(currency, fresh_rates)
    fresh_rates
  end
end
