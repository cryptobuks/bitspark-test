use Mix.Config

config :wallet, Wallet.Mailer,
  adapter: Bamboo.LocalAdapter,
  open_email_in_browser_url: "http://localhost:4000/sent_emails"

config :wallet, wallet_base_url: "http://localhost:8080"

config :wallet, Lightning,
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
