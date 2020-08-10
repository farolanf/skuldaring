defmodule SkuldaringWeb.Helpers do
  import Phoenix.LiveView

  alias Phoenix.LiveView.Socket
  alias Skuldaring.Repo
  alias Skuldaring.Accounts.User

  def handle_session(socket, %{} = session) do
    with user_id when not is_nil(user_id) <- session["user_id"],
      user when not is_nil(user) <- Repo.get(User, user_id)
    do
      socket |> assign(:user, user)
    else
      _ -> socket
    end
  end

  def handle_access_denied(%Socket{} = socket) do
    {:noreply, socket
    |> put_flash(:error, "Akses ditolak")
    |> push_redirect(to: "/")}
  end

end
