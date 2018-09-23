use Mix.Config

config :wallet_web, WalletWeb.Endpoint,
  load_from_system_env: true,
  url: [host: "testwallet.biluminate.com", port: 443],
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :wallet_web, :auth0,
  key: System.get_env("AUTH0_KEY") || "priv/auth/prod.pem"

# Do not print debug messages in production
config :logger, level: :info
