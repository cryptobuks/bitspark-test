defmodule Canteen do
  def lightning_config(), do: Application.get_env(:canteen, Lightning)

  def create_invoice(:piccolo) do
    lightning_config()
    |> Lightning.create_invoice(
      %{
        description: "☕ Piccolo",
        msatoshi: Bitcoin.to_msatoshi({"1", :satoshi})
      })
  end

  def create_invoice(:baguette) do
    lightning_config()
    |> Lightning.create_invoice(
      %{
        description: "🥖 Baguette",
        msatoshi: Bitcoin.to_msatoshi({"0.5", :mbtc})
      })
  end
end
