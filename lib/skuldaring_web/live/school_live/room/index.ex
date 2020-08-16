defmodule SkuldaringWeb.SchoolLive.Room.Index do
  use SkuldaringWeb, :live_component

  @impl true
  def handle_event(event, params, socket) do
    {:noreply, apply_event(event, params, socket)}
  end

  defp apply_event("open", %{"new-room-modal" => open}, socket) do
    socket
    |> assign(:new_room_modal, String.to_existing_atom(open))
  end
end
