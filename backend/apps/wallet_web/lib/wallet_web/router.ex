defmodule WalletWeb.Router do
  use WalletWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Joken.Plug, verify: &WalletWeb.Auth0.verify_function/0, on_error: &__MODULE__.auth_on_error/2
  end

  # Wallet API without auth (only safe handlers here)
  scope "/api/wallet", WalletWeb do
    pipe_through [:api]

    resources "/invoice", InvoiceController, only: [:show] # only show is safe
  end

  # With auth
  scope "/api/wallet", WalletWeb do
    pipe_through [:api, :auth]

    resources "/", WalletController, singleton: true, only: [:show]
    resources "/transactions", TransactionController, only: [:index, :show, :create]
    resources "/invoice", InvoiceController, only: []
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  if (Mix.env in [:dev, :test]) or (System.get_env("FAKE_LND_ENABLED") == "1") do
    alias FakeLndWeb
    scope "/fakelnd" do
      pipe_through [:api]

      forward "/", FakeLndWeb.Router
    end
  end

  def auth_on_error(conn, message) do
    {conn, %{"error" => %{"detail" => message}}}
  end
end
