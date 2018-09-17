use Mix.Config

config :wallet, ecto_repos: [Wallet.Repo]

config :wallet, Wallet.CurrencyRates.Coinbase,
  base_url: "http://localhost:4000/fakecoinbase"

config :gold, :wallet_btcd,
  hostname: System.get_env("WALLET_BTCD_HOST") || "localhost",
  port: System.get_env("WALLET_BTCD_PORT"),
  user: System.get_env("WALLET_BTCD_USER"),
  password: System.get_env("WALLET_BTCD_PASSWORD")

import_config "#{Mix.env}.exs"
