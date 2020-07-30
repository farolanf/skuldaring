use Mix.Config

config :skuldaring,
  logout_url: "http://docker:8080/auth/realms/skuldaring/protocol/openid-connect/logout?redirect_uri=http://localhost:4000/logout"

# Configure your database
config :skuldaring, Skuldaring.Repo,
  username: "postgres",
  password: "admin",
  database: "skuldaring_dev",
  hostname: "docker",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :skuldaring, SkuldaringWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :skuldaring, SkuldaringWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/skuldaring_web/(live|views)/.*(ex)$",
      ~r"lib/skuldaring_web/templates/.*(eex)$"
    ]
  ]

config :skuldaring, :openid_connect_providers,
  skuldaring: [
    discovery_document_uri: "http://docker:8080/auth/realms/skuldaring/.well-known/openid-configuration",
    client_id: "skuldaring",
    client_secret: "ae5f6142-864a-4b63-a5e0-bda97379ad6a",
    redirect_uri: "http://localhost:4000/session/new",
    response_type: "code",
    scope: "openid email profile"
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
