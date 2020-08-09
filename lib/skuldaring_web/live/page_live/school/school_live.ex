defmodule SkuldaringWeb.School.SchoolLive do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers

  alias Skuldaring.Schools

  @impl true
  def mount(_params, %{} = session, socket) do
    socket = socket
    |> handle_session(session)

    socket = case session do
      %{"user_id" => user_id} ->
        search_params = %{user_id: user_id}
        socket
        |> assign(:schools, Schools.find_schools(search_params))
      _ -> socket
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Daftar Sekolah")
    |> assign(:school, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Ubah Sekolah")
    |> assign(:school, Schools.get_school!(id))
  end

end
