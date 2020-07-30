defmodule SkuldaringWeb.NavLive.TopbarLive do
  use SkuldaringWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok, assign(socket, auth_url: OpenIDConnect.authorization_uri(:skuldaring))}
  end
end
