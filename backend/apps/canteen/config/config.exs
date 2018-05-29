use Mix.Config

config :canteen, Lightning,
  lnd_base_url: System.get_env("CANTEEN_LND_REST_URL"),
  lnd_macaroon: System.get_env("CANTEEN_LND_REST_MACAROON")

import_config "#{Mix.env}.exs"
