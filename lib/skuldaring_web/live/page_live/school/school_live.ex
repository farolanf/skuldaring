defmodule SkuldaringWeb.School.SchoolLive do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers

  alias Skuldaring.Schools

  @impl true
  def mount(_params, %{"user_id" => user_id} = session, socket) do
    Logger.debug "live session = #{inspect session}"

    search_params = %{user_id: user_id}

    socket = socket
    |> handle_session(session)
    |> assign(:schools, Schools.find_schools(search_params))

    {:ok, socket}
  end

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"

    socket = socket
    |> handle_session(session)

    {:ok, socket}
  end

end
