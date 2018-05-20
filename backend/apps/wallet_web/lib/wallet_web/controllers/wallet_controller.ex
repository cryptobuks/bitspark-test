defmodule WalletWeb.WalletController do
  use WalletWeb, :controller

  alias Wallet.Accounts
  alias Wallet.Wallets

  action_fallback WalletWeb.FallbackController

  def show(conn, %{}) do
    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Wallets.get_wallet!(id)

    with {:ok, %Wallets.Wallet{} = wallet} <- Wallets.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end
end
