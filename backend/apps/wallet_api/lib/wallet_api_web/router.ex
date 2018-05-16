defmodule WalletApiWeb.Router do
  use WalletApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Joken.Plug, verify: &WalletApiWeb.Auth0.verify_function/0
  end

  # Wallet API without auth (only safe handlers here)
  scope "/api/wallet", WalletApiWeb do
    pipe_through [:api]

    resources "/invoice", InvoiceController, only: [:show] # only show is safe
  end

  # With auth
  scope "/api/wallet", WalletApiWeb do
    pipe_through [:api, :auth]

    resources "/", WalletController, singleton: true, only: [:show]
    resources "/transactions", TransactionController, only: [:index, :show, :create]
    resources "/invoice", InvoiceController, only: []
  end

  if Mix.env in [:dev, :test] do
    alias FakeLndWeb
    scope "/fakelnd" do
      pipe_through [:api]

      forward "/", FakeLndWeb.Router
    end
  end
end
