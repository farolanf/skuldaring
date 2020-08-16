defmodule SkuldaringWeb.Helpers do
  import Phoenix.LiveView

  import Ecto.Query

  alias Phoenix.LiveView.Socket
  alias Skuldaring.Repo
  alias Skuldaring.Schools.School
  alias Skuldaring.Accounts.User

  def handle_session(socket, %{} = session) do
    with user_id when not is_nil(user_id) <- session["user_id"],
      user when not is_nil(user) <- Repo.get(User, user_id)
    do
      user = user
      |> Repo.preload(schools: from(s in School, order_by: s.name))
      socket |> assign(:user, user)
    else
      _ -> socket
    end
  end

  def handle_access_denied(%Socket{} = socket) do
    socket
    |> put_flash(:error, "Akses ditolak")
    |> push_redirect(to: "/")
  end

end
