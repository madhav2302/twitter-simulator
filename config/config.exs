# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config



config :twitter_simulator_web,
  generators: [context_app: :twitter_simulator]

# Configures the endpoint
config :twitter_simulator_web, TwitterSimulatorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "itFbs3B5gEqiLDNWUX4IGqCuY2a7QXsLbFo+2Uy1xtWPR+cbgkvwfxZbohn3rkfo",
  render_errors: [view: TwitterSimulatorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TwitterSimulatorWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
