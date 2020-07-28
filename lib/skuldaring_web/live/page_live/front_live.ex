defmodule SkuldaringWeb.PageLive.FrontLive do
  use SkuldaringWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{})}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

end
