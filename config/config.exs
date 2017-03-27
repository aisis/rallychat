# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :rallychat,
  ecto_repos: [Rallychat.Repo]

# Configures the endpoint
config :rallychat, Rallychat.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "aVFPP3wNVHdVhoKOrecZWFPx2sDDcuIwzJ2fBHG9AZrw96ixKFVRVHGFmw+utsbB",
  render_errors: [view: Rallychat.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Rallychat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
