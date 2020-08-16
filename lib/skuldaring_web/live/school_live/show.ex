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
  def handle_params(params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, apply_params(params, socket)}
  end

  defp apply_params(%{"slug" => slug, "room_slug" => room_slug}, socket) do
    id = id_from_slug(room_slug)

    room = Schools.get_room!(id)

    apply_params(%{"slug" => slug}, socket)
    |> assign(:room, room)
  end

  defp apply_params(%{"slug" => slug}, socket) do
    id = id_from_slug(slug)

    school = Schools.get_school!(id)

    socket
    |> assign(:school, school)
    |> assign(:page_title, school.name)
  end

end
