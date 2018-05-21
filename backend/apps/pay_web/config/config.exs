# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pay_web,
  namespace: PayWeb

# Configures the endpoint
config :pay_web, PayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bNZRX0D1FGETWUlpfOvqnRvE9qkN0GFeBDqedDjbC4m3rxW4LsOLbbjXil2Rgi7C",
  render_errors: [view: PayWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PayWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :pay_web, :generators,
  context_app: :pay

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
