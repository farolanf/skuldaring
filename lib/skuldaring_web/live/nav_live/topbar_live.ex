defmodule SkuldaringWeb.NavLive.TopbarLive do
  use SkuldaringWeb, :live_component

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end
end
