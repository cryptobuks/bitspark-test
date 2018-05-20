use Mix.Config

config :wallet, Wallet.Lightning,
  lnd_base_url: "http://localhost:4000/fakelnd",
  lnd_macaroon: "foobar"

# Configure your database
config :wallet, Wallet.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "wallet_dev",
  hostname: "localhost",
  pool_size: 10
