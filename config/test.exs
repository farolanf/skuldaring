use Mix.Config

database_url =
  System.get_env("TEST_DATABASE_URL") ||
    IO.puts """
    environment variable TEST_DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :skuldaring, Skuldaring.Repo,
  url: database_url,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :skuldaring, SkuldaringWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

import_config "test.secret.exs"
