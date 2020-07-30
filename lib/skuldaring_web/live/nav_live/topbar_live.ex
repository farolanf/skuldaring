defmodule SkuldaringWeb.NavLive.TopbarLive do
  use SkuldaringWeb, :live_component

  @impl true
  def mount(socket) do
    socket = socket
    |> assign(auth_url: OpenIDConnect.authorization_uri(:skuldaring))
    |> assign(logout_url: Application.get_env(:skuldaring, :logout_url))

    {:ok, socket}
  end
end
