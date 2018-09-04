use Mix.Config

config :wallet, Wallet.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.get_env("WALLET_MAILGUN_API_KEY"),
  domain: System.get_env("WALLET_MAILGUN_DOMAIN") || "mailgun.biluminate.com"


config :wallet, Lightning,
  lnd_base_url: System.get_env("WALLET_LND_REST_URL"),
  lnd_macaroon: System.get_env("WALLET_LND_REST_MACAROON")

config :wallet, Wallet.CurrencyRates.Coinbase,
  base_url: "https://api.coinbase.com"

# Configure your database
config :wallet, Wallet.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("PGUSER") || "postgres",
  password: System.get_env("PGPASSWORD") || "postgres",
  database: System.get_env("PGDATABASE") || "postgres",
  hostname: System.get_env("PGHOST") || "localhost",
  pool_size: 15

# Do not print debug messages in production
config :logger, level: :info
