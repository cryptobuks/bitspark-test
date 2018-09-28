defmodule Bitcoin.Lightning do
  @moduledoc """
  Lightning functions.
  """

  alias Bitcoin.Lightning.LndRest
  alias Bitcoin.Lightning.Invoice

  @doc """
  Return info stored in invoice.

      iex> Wallet.lightning_config |> Bitcoin.Lightning.decode_invoice("lntb1500n1pd0c66dpp5p8rpzxck9u7umfl9u7dqratj8rlfthe29xl6ejhwt2exuaxfpftqdqvg9jxgg8zn2sscqzysyv8kgctq7haghaus4wqd262mxr9342mvp23gdsv6vmgkce9zgshjd0av06dq3xpe8cy6fucnj454smkqxuetyvu3h5jggx2w8ethlvcp6g3ldq")
      {:ok,
        %{
          description: "Foobar #ldq",
          dst_pub_key: "039cc950286a8fa99218283d1adc2456e0d5e81be558da77dd6e85ba9a1fff5ad3",
          msatoshi: 150000
        }
      }

  """
  def decode_invoice(config, invoice) do
    with %{status: 200, body: body} <- LndRest.xget!(config, "/v1/payreq/#{invoice}") do
      changeset = Bitcoin.Lightning.Invoice.changeset(
        %Invoice{},
        %{
          description: body["description"],
          msatoshi: String.to_integer(body["num_satoshis"]) * 1000,
          dst_pub_key: body["destination"]
        })

      case changeset.valid? do
        true -> {:ok, changeset.changes}
        false -> {:error, changeset.errors}
      end
    else
      %{status: 500} ->
        {:error, "Failed to decode invoice"}
    end
  end

  @doc """
  Get list of invoices from LND database.

      Wallet.lightning_config |> Bitcoin.Lightning.get_invoices()
      [
        %{
          "cltv_expiry" => "144",
          "creation_date" => "1529592729",
          "expiry" => "3600",
          "memo" => "Refill",
          "payment_request" => "lntb40m1pdjhwuepp5lk8d6huv5r5zwxqz8qrzpdthnevt4gaura562xnucns09rwegkssdq22fjkv6tvdscqzysyf9r4q8803k3q8yph8mgwtzrhmrwx5em43lj64k870u5z6mvh89q0zhz80e3ccesge953hqaaw0e2n8e9tvasste52k27g8a584kugqqtnh87s",
          "r_hash" => "/Y7dX4yg6CcYAjgGILV3nli6o7wfaaUafMTg8o3ZRaE=",
          "r_preimage" => "y6H4ItNwjLPSZlnDGQRdzM5xJYe6ztx1AgNpTFQTszE=",
          "settle_date" => "1529592763",
          "settled" => true,
          "value" => "4000000"
        }
      ]

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

  @doc """
  Return basic information about given node

      iex> Wallet.lightning_config |> Bitcoin.Lightning.get_node_info("02212d3ec887188b284dbb7b2e6eb40629a6e14fb049673f22d2a0aa05f902090e")
      {:ok, %{alias: "SomeNodeAlias #022"}}

  """
  def get_node_info(config, node_pub_key) do
    %{body: body} =
      LndRest.xget!(config, "/v1/graph/node/#{node_pub_key}")

    case body do
      %{"node" => node} ->
        {:ok, %{alias: node["alias"]}}
      _ -> {:error, body}
    end
  end


  @doc """
  Create lightning invoice

      iex> Canteen.lightning_config |> Bitcoin.Lightning.create_invoice(%{description: "Thing", msatoshi: 1000})
      {:ok, "lntb1230n1pdselh0pp5nlmxmjhf6w7uy4sqrwe4tputzd5m2y9a22p7l2dvxrxtfc8aq3dqdqdgfskwat9w36x2cqzys4gyv0cd7kg0wa54h4h5x9d75303rpks50d47fc26hahw9wv3z68kslw3x2xx6ghcf5ld77u0q6sx20y0y4het8kfgauamspjwn4s6zcpv36uz6"}

  """

  def create_invoice(config, %{description: description, msatoshi: msatoshi}) do
    %{body: body} =
      LndRest.xpost!(
        config, "/v1/invoices", %{memo: description, value: Bitcoin.Amount.to_satoshi({msatoshi, :msatoshi})})

    case body do
      %{"payment_request" => invoice} -> {:ok, invoice}
      _ -> {:error, body}
    end
  end

  @doc """
  Pay given invoice

      iex> Canteen.lightning_config |> Bitcoin.Lightning.pay_invoice("lntb10n1pdctf20pp5s6aj9rum8rez4w93058a7hheqdtq2vmex8a7j8e87jxcqgqlx32sdqg235xjmn8cqzysttrrdt3yucpl6dfzrke47cp3pxea5km99ujgj2ttagx80s9xmznqh778gctz87azkm6cvr3qqxxyecayfa78r7j00mfuae40n468wccp3f0mlv")
      {:ok,
        %{
          "payment_preimage" => "+b9n1eSD0DlPhIdh8JowwMhQfJXEAsxV6RAspa4OJRA=",
          "payment_route" => %{
          "hops" => [
            %{
              "amt_to_forward" => "1",
              "chan_capacity" => "897123",
              "chan_id" => "1420515147023712256",
              "expiry" => 1292164,
              "fee" => "1"
            },
            %{
              "amt_to_forward" => "100",
              "chan_capacity" => "1000000",
              "chan_id" => "1417756472375115776",
              "expiry" => 1292164
            }
          ],
          "total_amt" => "2",
          "total_fees" => "1",
          "total_time_lock" => 1292308
        }
      }}

  """
  def pay_invoice(config, invoice) do
    %{body: body} = LndRest.xpost!(
      config, "/v1/channels/transactions", %{payment_request: invoice})

    case body do
      %{"payment_preimage" => _} -> {:ok, body}
      _ -> {:error, body}
    end
  end
end
