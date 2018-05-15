# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wallet_api,
  namespace: WalletApi,
  ecto_repos: [WalletApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :wallet_api, WalletApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6Zk9BtKb1H//sxtp1zezzSKJeS1MZvocl2v+A978TsMw/11v9Rm6elXRv789CTRz",
  render_errors: [view: WalletApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WalletApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# JWT tokens
config :wallet_api, :auth0,
  issuer: System.get_env("AUTH0_ISSUER") || "https://biluminate.eu.auth0.com/",
  aud: System.get_env("AUTH0_AUD") || "https://biluminate.net/auth",
  key: System.get_env("AUTH0_KEY") || "priv/auth/dev.pem" # https://biluminate.eu.auth0.com/.well-known/jwks.json

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
