defmodule SkuldaringWeb.SchoolLive.Edit do
  use SkuldaringWeb, :live_view

  import Ecto.Query
  import Skuldaring.Permissions

  alias Skuldaring.{Repo, Schools}
  alias Schools.Room

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
    %{user: user, school: school} = socket.assigns

    socket = socket
    |> assign(:uri, URI.parse(uri))

    socket = if !allow?(user, school, "view") do
      handle_access_denied(socket)
    else
      socket
    end

    {:noreply, apply_action(socket.assigns.live_action, params, socket)}
  end

  defp apply_action(:index, _params, socket) do
    socket
    |> assign(:changeset, Schools.change_school(socket.assigns.school))
  end

  defp apply_action(:room_index, _params, socket) do
    school = socket.assigns.school
    |> Repo.preload(rooms: from(r in Room, order_by: r.name))

    socket
    |> assign(school: school)
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

end
