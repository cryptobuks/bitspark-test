use Mix.Config

config :wallet, ecto_repos: [Wallet.Repo]

config :wallet, Wallet.CurrencyRates.Coinbase,
  base_url: "http://localhost:4000/fakecoinbase"

import_config "#{Mix.env}.exs"
