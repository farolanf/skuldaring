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

end
