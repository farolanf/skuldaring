defmodule SkuldaringWeb.SchoolLive.Edit do
  use SkuldaringWeb, :live_view

  import Skuldaring.Permissions

  alias Skuldaring.Schools

  @impl true
  def mount(%{"id" => id}, %{} = session, socket) do
    school = Schools.get_school!(id)

    socket = socket
    |> handle_session(session)
    |> assign(:school, school)
    |> assign(:page_title, "Atur Sekolah")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, apply_action(socket.assigns.live_action, params, socket)}
  end

  defp apply_action(:index, _params, socket) do
    socket
    |> assign(:changeset, Schools.change_school(socket.assigns.school))
  end

  defp apply_action(:room_index, _params, socket) do
    school = socket.assigns.school

    rooms = Schools.list_rooms(%{where: %{school_id: school.id}})

    socket
    |> assign(:rooms, rooms)
  end

  defp apply_action(:room_edit, %{"room_id" => room_id}, socket) do
    %{user: user} = socket.assigns

    room = Schools.get_room!(room_id)

    if !allow?(user, room, "view") do
      handle_access_denied(socket)
    else
      socket
      |> assign(:room, room)
    end
  end

  @impl true
  def handle_event(event, params, socket) do
    {:noreply, apply_event(event, params, socket)}
  end

  defp apply_event("open", %{"new-room-modal" => open}, socket) do
    socket
    |> assign(:new_room_modal, String.to_existing_atom(open))
  end

end
