defmodule SkuldaringWeb.FrontLive.Index do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers

  @impl true
  def mount(_params, session, socket) do
    socket = socket
    |> handle_session(session)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, socket}
  end

end
