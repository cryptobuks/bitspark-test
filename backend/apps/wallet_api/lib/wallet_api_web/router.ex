defmodule WalletApiWeb.Router do
  use WalletApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Joken.Plug, verify: &WalletApiWeb.Auth0.verify_function/0
  end

  scope "/api", WalletApiWeb do
    pipe_through [:api, :auth]

    resources "/wallet", WalletController, singleton: true
    resources "/wallet/transactions", TransactionController, except: [:new, :edit]
    resources "/wallet/invoice", InvoiceController, except: [:new, :edit]
  end

  if Mix.env in [:dev, :test] do
    alias FakeLndWeb
    scope "/fakelnd" do
      pipe_through [:api]

      forward "/", FakeLndWeb.Router
    end
  end
end
