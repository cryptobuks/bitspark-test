# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wallet_web,
  namespace: WalletWeb,
  ecto_repos: [Wallet.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :wallet_web, WalletWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "O4TlOvrI9TKTulX1QANJSkvKuIefrF9JU9EyuXue3D3+DFL78YendjgTdXWQ1V+J",
  render_errors: [view: WalletWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WalletWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# JWT tokens
config :wallet_web, :auth0,
  issuer: System.get_env("AUTH0_ISSUER") || "https://biluminate.eu.auth0.com/",
  aud: System.get_env("AUTH0_AUD") || "https://biluminate.net/auth",
  key: System.get_env("AUTH0_KEY") || "priv/auth/dev.pem" # https://biluminate.eu.auth0.com/.well-known/jwks.json

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :wallet_web, :generators,
  context_app: :wallet

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
