defmodule SkuldaringWeb.School.SchoolLive do
  use SkuldaringWeb, :live_view

  require Logger

  import SkuldaringWeb.Helpers

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"
    socket = handle_session(socket, session)
    {:ok, socket}
  end

end
