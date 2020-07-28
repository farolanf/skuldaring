# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :skuldaring,
  ecto_repos: [Skuldaring.Repo]

config :skuldaring, :pow,
  user: Skuldaring.Users.User,
  repo: Skuldaring.Repo,
  web_module: SkuldaringWeb

# Configures the endpoint
config :skuldaring, SkuldaringWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9cAppGTyiHVQ38BmxZ4/m9dP3Mn7WplVBN5gyrkpnQ5Vipdj7PjNghMkyQR9C3ap",
  render_errors: [view: SkuldaringWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Skuldaring.PubSub,
  live_view: [signing_salt: "uagI/gV8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
