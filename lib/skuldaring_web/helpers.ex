defmodule SkuldaringWeb.Helpers do

  import Phoenix.LiveView

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

end
