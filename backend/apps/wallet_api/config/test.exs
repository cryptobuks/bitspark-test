use Mix.Config

port = 4001

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :wallet_api, WalletApiWeb.Endpoint,
  http: [port: port],
  server: true

config :wallet_api, WalletApi.Lightning,
  lnd_base_url: "http://localhost:#{port}/fakelnd",
  lnd_macaroon: "foobar"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wallet_api, WalletApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wallet_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
