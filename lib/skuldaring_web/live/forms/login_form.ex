defmodule SkuldaringWeb.Forms.LoginForm do
  use SkuldaringWeb, :live_component

  @impl true
  def handle_event("login", %{"user" => _user_params}, socket) do
    {:noreply, socket}
  end

end
