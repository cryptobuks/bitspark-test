defmodule WalletApiWeb.WalletController do
  use WalletApiWeb, :controller

  alias WalletApi.Accounts
  alias WalletApi.Wallets
  alias WalletApi.Wallets.Wallet

  action_fallback WalletApiWeb.FallbackController

  def show(conn, %{}) do
    user = Accounts.login!(conn.assigns.joken_claims["sub"])
    wallet = Wallets.get_or_create_wallet!(user)

    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Wallets.get_wallet!(id)

    with {:ok, %Wallet{} = wallet} <- Wallets.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end
end
