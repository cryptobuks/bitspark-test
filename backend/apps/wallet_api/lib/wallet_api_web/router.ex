defmodule WalletApiWeb.Router do
  use WalletApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WalletApiWeb do
    pipe_through :api

    resources "/wallet", WalletController, singleton: true
    resources "/wallet/transactions", TransactionController, except: [:new, :edit]
  end
end
