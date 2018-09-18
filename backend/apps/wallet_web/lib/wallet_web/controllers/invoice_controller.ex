defmodule WalletWeb.InvoiceController do
  use WalletWeb, :controller

  action_fallback WalletWeb.FallbackController

  def show(conn, %{"id" => id}) do
    id = String.downcase(id)

    {:ok, invoice} = Bitcoin.Lightning.decode_invoice(Wallet.lightning_config, id)
    {:ok, node} = Bitcoin.Lightning.get_node_info(Wallet.lightning_config, invoice.dst_pub_key)
    invoice = Map.put(invoice, :dst_alias, node.alias)
    render(conn, "show.json", invoice: invoice)
  end
end
