defmodule WalletApiWeb.WalletController do
  use WalletApiWeb, :controller

  alias WalletApi.Wallets
  alias WalletApi.Wallets.Wallet

  action_fallback WalletApiWeb.FallbackController

  @users_wallet_id "20000000-0000-0000-0000-000000000001"

  def show(conn, %{}) do
    wallet = Wallets.get_wallet!(@users_wallet_id)
    render(conn, "show.json", wallet: wallet)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Wallets.get_wallet!(id)

    with {:ok, %Wallet{} = wallet} <- Wallets.update_wallet(wallet, wallet_params) do
      render(conn, "show.json", wallet: wallet)
    end
  end
end
