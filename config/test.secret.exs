use Mix.Config

frontend_url = System.get_env("FRONTEND_URL") ||
  IO.puts "env FRONTEND_URL is missing"

keycloak_url = System.get_env("KEYCLOAK_URL") ||
  IO.puts "env KEYCLOAK_URL is missing"

keycloak_client_id = System.get_env("KEYCLOAK_CLIENT_ID") ||
  IO.puts "env KEYCLOAK_CLIENT_ID is missing"

keycloak_client_secret = System.get_env("KEYCLOAK_CLIENT_SECRET") ||
  IO.puts "env KEYCLOAK_CLIENT_SECRET is missing"

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
