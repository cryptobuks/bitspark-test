defmodule WalletWeb.Router do
  use WalletWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Joken.Plug,
      verify: &WalletWeb.Auth0.verify_function/0,
      on_error: &__MODULE__.auth_on_error/2
    plug WalletWeb.Absinthe.AuthPlug
  end

  pipeline :basic_auth do
    plug BasicAuth, callback: &__MODULE__.verify_basic_auth/3, realm: "Biluminate"
  end

  # Public API
  scope "/api"  do
    pipe_through [:api]

    get "/rates/:currency", WalletWeb.RatesController, :show
  end

  # GraphiQL
  scope "/api/graphiql"  do
    pipe_through [:api, :basic_auth]

    forward "/", Absinthe.Plug.GraphiQL,
      schema: Wallet.Schema,
      socket: WalletWeb.UserSocket,
      interface: :advanced,
      context: %{pubsub: WalletWeb.Endpoint},
      default_url: "/api/q",
      default_headers: {__MODULE__, :graphiql_headers}
  end


  # Wallet API without auth (only safe handlers here)
  scope "/api/wallet", WalletWeb do
    pipe_through [:api]

    resources "/invoice", InvoiceController, only: [:show] # only show is safe
  end

  # With auth (GraphQL)
  scope "/api" do
    pipe_through [:api, :auth]

    forward "/q", Absinthe.Plug,
      schema: Wallet.Schema
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

    alias FakeCoinbaseWeb
    scope "/fakecoinbase" do
      pipe_through [:api]

      forward "/", FakeCoinbaseWeb.Router
    end
  end

  def auth_on_error(conn, message) do
    {conn, %{"error" => %{"detail" => message}}}
  end

  def verify_basic_auth(conn, token, _password) do
    with %Joken.Token{error: nil, claims: claims} <- WalletWeb.Auth0.verify_token(token) do
      Plug.Conn.assign(conn, :joken_claims, claims)
      Plug.Conn.assign(conn, :token, token)
    else
      _ ->
        Plug.Conn.halt(conn)
    end
  end

  def graphiql_headers(conn) do
    %{
      "Authorization" => "Bearer " <> conn.assigns[:token]
    }
  end
end
