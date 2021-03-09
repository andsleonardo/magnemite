# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :magnemite,
  ecto_repos: [Magnemite.Repo],
  generators: [binary_id: true],
  migration_primary_key: [name: :uuid, type: :binary_id],
  migration_foreign_key: [name: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime]

# Configures the endpoint
config :magnemite, MagnemiteWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sq6kBokOmuCrPKGCHxiPaGIt/2ltP5xofI1OKHE87eWsbY2VL3YI+cDo9NsykFOf",
  render_errors: [view: MagnemiteWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Magnemite.PubSub,
  live_view: [signing_salt: "jl1tj2kN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :magnemite, Magnemite.Identity.Guardian,
  issuer: "Magnemite",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
