defmodule Lightning do
  @moduledoc """
  Lightning functions.
  """

  alias Lightning.LndRest
  alias Lightning.Invoice

  def decode_invoice(config, invoice) do
    %{body: body} = LndRest.xget!(config, "/v1/payreq/#{invoice}")

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

    %{body: body} = LndRest.xget!(config, url)
    body |> Map.get("invoices")
  end

  def get_node_info(config, node_pub_key) do
    %{body: body} =
      LndRest.xget!(config, "/v1/graph/node/#{node_pub_key}")

    case body do
      %{"node" => node} ->
        {:ok, %{alias: node["alias"]}}
      _ -> {:error, body}
    end
  end

  def create_invoice(config, %{description: description, msatoshi: msatoshi}) do
    %{body: body} =
      LndRest.xpost!(
        config, "/v1/invoices", %{memo: description, value: Bitcoin.to_satoshi({msatoshi, :msatoshi})})

    case body do
      %{"payment_request" => invoice} -> {:ok, invoice}
      _ -> {:error, body}
    end
  end

  def pay_invoice(config, invoice) do
    %{body: body} = LndRest.xpost!(
      config, "/v1/channels/transactions", %{payment_request: invoice})

    case body do
      %{"payment_preimage" => _} -> {:ok, body}
      _ -> {:error, body}
    end
  end
end
