defmodule SkuldaringWeb.SchoolLive.Front do
  use SkuldaringWeb, :live_view

  import SkuldaringWeb.Helpers

  @impl true
  def mount(params, %{} = session, socket) do
    socket = socket
    |> handle_session(session)


    IO.inspect params, label: "params"

    {:ok, socket}
  end

end
