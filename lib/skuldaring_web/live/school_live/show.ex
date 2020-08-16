defmodule SkuldaringWeb.SchoolLive.Show do
  use SkuldaringWeb, :live_view

  import SkuldaringWeb.Helpers

  alias Skuldaring.Schools

  @impl true
  def mount(%{"id" => id}, %{} = session, socket) do
    school = Schools.get_school!(id)

    socket = socket
    |> handle_session(session)
    |> assign(:school, school)
    |> assign(:page_title, school.name)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, socket}
  end

end
