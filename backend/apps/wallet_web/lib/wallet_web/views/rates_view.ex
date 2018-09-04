defmodule WalletWeb.RatesView do
  use WalletWeb, :view
  alias WalletWeb.RatesView

  def render("show.json", %{rates: rates}) do
    %{data: render_one(rates, RatesView, "currency_rates.json")}
  end

  def render("currency_rates.json", %{rates: %{"currency" => currency, "rates" => rates}}) do
    %{
      currency => rates
    }
  end
end
