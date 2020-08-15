defmodule SkuldaringWeb.SchoolLive.Edit do
  use SkuldaringWeb, :live_view

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
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket.assigns.live_action, params, socket)}
  end

  defp apply_action(:index, _params, socket), do: socket

  defp apply_action(:room_index, _params, socket) do
    school = socket.assigns.school

    rooms = Schools.find_rooms(%{where: %{school_id: school.id}})

    socket
    |> assign(:rooms, rooms)
  end

end
