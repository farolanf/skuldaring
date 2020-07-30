defmodule SkuldaringWeb.PageLive.FrontLive do
  use SkuldaringWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    IO.inspect session, label: "live session"
    {:ok, socket}
  end

end
