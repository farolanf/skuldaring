defmodule SkuldaringWeb.ModalComponent do
  use SkuldaringWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="reveal-overlay" style="display: block"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading
    >
      <div id="<%= @id %>" class="reveal" data-reveal style="display: block">
        <%= live_patch raw("&times;"), to: @return_to, class: "close-button" %>
        <%= render(Pow.Phoenix.SessionView, "session/new.html.eex", @opts) %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
