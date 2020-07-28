defmodule SkuldaringWeb.Forms.LoginForm do
  use SkuldaringWeb, :live_component

  @impl true
  def handle_event("validate", %{"email" => _email, "password" => _password}, socket) do
    {:noreply, socket}
  end

end
