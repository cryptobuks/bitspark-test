defmodule Lightning do
  @moduledoc """
  The Lnd context.

  LND REST API: https://api.lightning.community/rest/index.html
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

  @doc """
  Issue GET request to given LND.

      Wallet.lightning_config |> Lightning.xget!("/v1/getinfo")

  """
  def xget!(config, path) do
    client(config)
    |> get!(path)
  end

  @doc """
  Issue POST request to given LND.

      Wallet.lightning_config |> Lightning.xpost!("/v1/invoices", %{memo: "...description", value: 12345, receipt: Base.encode64("...receipt")})

  """
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

  @doc """
  Get list of invoices from LND database.

      Wallet.lightning_config |> Lightning.get_invoices()

  """
  def get_invoices(config, pending_only \\ false) do
    url = if pending_only do
      "/v1/invoices?pending_only=1"
    else
      "/v1/invoices"
    end

    %{body: body} = client(config) |> get!(url)
    body |> Map.get("invoices")
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
