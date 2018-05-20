defmodule WalletWeb.WalletView do
  use WalletWeb, :view
  alias WalletWeb.WalletView

  def render("index.json", %{wallets: wallets}) do
    %{data: render_many(wallets, WalletView, "wallet.json")}
  end

  def render("show.json", %{wallet: wallet}) do
    %{data: render_one(wallet, WalletView, "wallet.json")}
  end

  def render("wallet.json", %{wallet: wallet}) do
    %{
      id: wallet.id,
      balance: %{
        msatoshi: wallet.balance
      }
    }
  end
end
