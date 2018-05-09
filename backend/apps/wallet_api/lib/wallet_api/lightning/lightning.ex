defmodule WalletApi.Lightning do
  @moduledoc """
  The Lnd context.
  """
  use Tesla
  plug Tesla.Middleware.BaseUrl, config(:lnd_base_url)
  plug Tesla.Middleware.Headers, [{"grpc-metadata-macaroon", config(:lnd_macaroon)}]
  plug Tesla.Middleware.JSON, engine: Poison

  alias WalletApi.Lightning.Invoice

  def config(key) do
    Application.get_env(:wallet_api, WalletApi.Lightning)
    |> Keyword.get(key)
  end

  def decode_invoice(invoice) do
    %{body: body} = get!("/v1/payreq/#{invoice}")
    changeset = WalletApi.Lightning.Invoice.changeset(
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
    %{body: body} = post!("/v1/channels/transactions", %{payment_request: invoice})
    case body do
      %{"payment_preimage" => _} -> {:ok, body}
      _ -> {:error, body}
    end
  end
end
