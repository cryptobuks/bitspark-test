use Mix.Config

config :wallet, ecto_repos: [Wallet.Repo]

import_config "#{Mix.env}.exs"
