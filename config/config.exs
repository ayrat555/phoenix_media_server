# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :media_server,
  ecto_repos: [MediaServer.Repo],
  file: [part_size: 1024 * 1024 * 5,
         max_parts_number: 10_000,
         sync_part_number: 10],
  riak_cs: [key_id: "key",
            secret_key: "secret",
            exp_days: 1,
            schema: "https",
            host: "storage-nginx.stage.govermedia.com",
            acl: "public-read"]

# Configures the endpoint
config :media_server, MediaServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XFVsLoR2LOCZELkKyqBFhU4BqPq+elEjoJE7wZF3koZKb1D2NJvmTxCz2ZS/DkFP",
  render_errors: [view: MediaServer.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MediaServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
