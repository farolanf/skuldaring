defmodule SkuldaringWeb.FrontLive do
  use SkuldaringWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end
end
