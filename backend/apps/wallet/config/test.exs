use Mix.Config

config :wallet, Wallet.Mailer,
  adapter: Bamboo.TestAdapter

config :wallet, wallet_base_url: "http://test:4000"

config :wallet, Lightning,
  lnd_base_url: "http://localhost:4001/fakelnd",
  lnd_macaroon: "foobar"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :wallet, Wallet.Repo,
  timeout: :infinity,
  ownership_timeout: :infinity,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wallet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
