defmodule Lightning.LndRest do
  @moduledoc """
  Low level LND REST API client.

  LND REST API: https://api.lightning.community/rest/index.html
  """
  use Tesla
  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Timeout, timeout: 120_000 #ms
  plug Tesla.Middleware.Logger

  defp client(config) do
    base_url = Keyword.get(config, :lnd_base_url)
    macaroon = Keyword.get(config, :lnd_macaroon)

    Tesla.build_client([
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers, [{"grpc-metadata-macaroon", macaroon}]}
    ])
  end

  @doc """
  Issue GET request to given LND.

      Wallet.lightning_config |> Lightning.LndRest.xget!("/v1/getinfo")

  """
  def xget!(config, path) do
    client(config)
    |> get!(path)
  end

  @doc """
  Issue POST request to given LND.

      Wallet.lightning_config |> Lightning.LndRest.xpost!("/v1/invoices", %{memo: "...description", value: 12345, receipt: Base.encode64("...receipt")})

  """
  def xpost!(config, path, data) do
    client(config)
    |> post!(path, data)
  end
end
