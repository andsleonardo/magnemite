use Mix.Config

mix_test_partition = System.get_env("MIX_TEST_PARTITION")
port = String.to_integer(System.get_env("PORT", "4002"))

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :magnemite, Magnemite.Repo,
  username: System.get_env("DATABASE_USERNAME", "postgres"),
  password: System.get_env("DATABASE_PASSWORD", "postgres"),
  database: System.get_env("DATABASE_NAME", "magnemite_test#{mix_test_partition}"),
  hostname: System.get_env("DATABASE_HOSTNAME", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :magnemite, MagnemiteWeb.Endpoint,
  http: [port: port],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir,
  # Low time cost and memory usage in test mode
  t_cost: 1,
  m_cost: 8
