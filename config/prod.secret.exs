# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("TEST_DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :skuldaring, Skuldaring.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :skuldaring, SkuldaringWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :skuldaring, SkuldaringWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

frontend_url = System.get_env("FRONTEND_URL") ||
  raise "env FRONTEND_URL is missing"

keycloak_url = System.get_env("KEYCLOAK_URL") ||
  raise "env KEYCLOAK_URL is missing"

keycloak_client_id = System.get_env("KEYCLOAK_CLIENT_ID") ||
  raise "env KEYCLOAK_CLIENT_ID is missing"

keycloak_client_secret = System.get_env("KEYCLOAK_CLIENT_SECRET") ||
  raise "env KEYCLOAK_CLIENT_SECRET is missing"

config :skuldaring, :openid_connect_providers,
  skuldaring: [
    # discovery_document_uri: "http://docker:8080/auth/realms/skuldaring/.well-known/openid-configuration",
    discovery_document_uri: "#{keycloak_url}/auth/realms/skuldaring/.well-known/openid-configuration",
    client_id: keycloak_client_id,
    client_secret: keycloak_client_secret,
    redirect_uri: "#{frontend_url}/session/new",
    response_type: "code",
    scope: "openid email profile"
  ]

config :skuldaring,
  logout_url: "#{keycloak_url}/auth/realms/skuldaring/protocol/openid-connect/logout?redirect_uri=#{frontend_url}/logout",
  registration_url: "#{keycloak_url}/auth/realms/skuldaring/protocol/openid-connect/registrations?client_id=skuldaring&redirect_uri=#{frontend_url}/session/new&response_type=code&scope=openid+email+profile"
