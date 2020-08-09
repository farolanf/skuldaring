defmodule SkuldaringWeb.School.SchoolLive do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers

  alias Skuldaring.Schools

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"

    socket = socket
    |> handle_session(session)
    |> assign(:schools, Schools.find_schools(%{where: %{name: "TK Lontar"}}))

    {:ok, socket}
  end

end
