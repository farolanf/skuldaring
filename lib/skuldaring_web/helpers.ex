defmodule SkuldaringWeb.Helpers do
  import Phoenix.LiveView

  import Recase

  alias Phoenix.LiveView.Socket
  alias Skuldaring.Accounts

  def handle_session(socket, %{} = session) do
    with user_id when not is_nil(user_id) <- session["user_id"],
      user when not is_nil(user) <- Accounts.get_user!(user_id)
    do
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

  def school_visit_path(school) do
    "/visit/#{to_kebab(school.name)}-#{school.id}"
  end

  def id_from_slug(slug) do
    slug
    |> String.split("-")
    |> List.last
  end

end
