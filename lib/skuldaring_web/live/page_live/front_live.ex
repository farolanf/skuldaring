defmodule SkuldaringWeb.PageLive.FrontLive do
  use SkuldaringWeb, :live_view

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"
    {:ok, assign(socket, :user, session["user"])}
  end

end
