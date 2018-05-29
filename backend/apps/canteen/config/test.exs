use Mix.Config

config :canteen, Lightning,
  lnd_base_url: "http://localhost:4001/fakelnd",
  lnd_macaroon: "foobar"
