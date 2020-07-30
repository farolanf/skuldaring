defmodule Skuldaring.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Skuldaring.Repo,
      # Start the Telemetry supervisor
      SkuldaringWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Skuldaring.PubSub},
      # Start the Endpoint (http/https)
      SkuldaringWeb.Endpoint,
      # Start a worker by calling: Skuldaring.Worker.start_link(arg)
      # {Skuldaring.Worker, arg}
      {OpenIDConnect.Worker, Application.get_env(:skuldaring, :openid_connect_providers)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Skuldaring.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SkuldaringWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
