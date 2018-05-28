defmodule Wallet.Lightning do
  @moduledoc """
  The Lnd context.
  """
  use Tesla
  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Timeout, timeout: 120_000 #ms
  plug Tesla.Middleware.Logger

  alias Wallet.Lightning.Invoice

  def config(key) do
    Application.get_env(:wallet, Wallet.Lightning)
    |> Keyword.get(key)
  end

  def client() do
    Tesla.build_client([
      {Tesla.Middleware.BaseUrl, config(:lnd_base_url)},
      {Tesla.Middleware.Headers, [{"grpc-metadata-macaroon", config(:lnd_macaroon)}]}
    ])
  end

  def decode_invoice(invoice) do
    %{body: body} = client() |> get!("/v1/payreq/#{invoice}")
    changeset = Wallet.Lightning.Invoice.changeset(
      %Invoice{},
      %{
        "description": body["description"],
        "msatoshi": String.to_integer(body["num_satoshis"]) * 1000,
      })

    case changeset.valid? do
      true -> {:ok, changeset.changes}
      false -> {:error, changeset.errors}
    end
  end

  def pay_invoice(invoice) do
    %{body: body} = client() |> post!("/v1/channels/transactions", %{payment_request: invoice})
    case body do
      %{"payment_preimage" => _} -> {:ok, body}
      _ -> {:error, body}
    end
  end
end
