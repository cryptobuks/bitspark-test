defmodule Lightning do
  @moduledoc """
  The Lnd context.
  """
  use Tesla
  plug Tesla.Middleware.JSON, engine: Poison
  plug Tesla.Middleware.Timeout, timeout: 120_000 #ms
  plug Tesla.Middleware.Logger

  alias Lightning.Invoice

  def client(config) do
    base_url = Keyword.get(config, :lnd_base_url)
    macaroon = Keyword.get(config, :lnd_macaroon)

    Tesla.build_client([
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers, [{"grpc-metadata-macaroon", macaroon}]}
    ])
  end

  def xget!(config, path) do
    client(config)
    |> get!(path)
  end

  def xpost!(config, path, data) do
    client(config)
    |> post!(path, data)
  end

  def decode_invoice(config, invoice) do
    %{body: body} = client(config) |> get!("/v1/payreq/#{invoice}")
    changeset = Lightning.Invoice.changeset(
      %Invoice{},
      %{
        "description": body["description"],
        "msatoshi": String.to_integer(body["num_satoshis"]) * 1000,
        "dst_pub_key": body["destination"]
      })

    case changeset.valid? do
      true -> {:ok, changeset.changes}
      false -> {:error, changeset.errors}
    end
  end

  def get_node_info(config, node_pub_key) do
    %{body: body} =
      client(config)
      |> get!("/v1/graph/node/#{node_pub_key}")
    case body do
      %{"node" => node} ->
        {:ok, %{alias: node["alias"]}}
      _ -> {:error, body}
    end
  end

  def create_invoice(config, %{description: description, msatoshi: msatoshi}) do
    %{body: body} =
      client(config)
      |> post!("/v1/invoices", %{memo: description, value: Bitcoin.to_satoshi({msatoshi, :msatoshi})})
    case body do
      %{"payment_request" => invoice} -> {:ok, invoice}
      _ -> {:error, body}
    end
  end

  def pay_invoice(config, invoice) do
    %{body: body} = client(config) |> post!("/v1/channels/transactions", %{payment_request: invoice})
    case body do
      %{"payment_preimage" => _} -> {:ok, body}
      _ -> {:error, body}
    end
  end
end
