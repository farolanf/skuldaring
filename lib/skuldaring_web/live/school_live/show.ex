defmodule SkuldaringWeb.SchoolLive.Show do
  use SkuldaringWeb, :live_view

  import SkuldaringWeb.Helpers

  alias Skuldaring.Schools

  @impl true
  def mount(_params, %{} = session, socket) do
    socket = socket
    |> handle_session(session)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    socket
    |> assign(:school, Schools.get_school!(id))

    {:noreply, socket}
  end

end
