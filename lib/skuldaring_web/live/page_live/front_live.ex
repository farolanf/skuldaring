defmodule SkuldaringWeb.PageLive.FrontLive do
  use SkuldaringWeb, :live_view

  require Logger

  alias Skuldaring.Repo
  alias Skuldaring.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"
    socket = with user_id when not is_nil(user_id) <- session["user_id"],
      user when not is_nil(user) <- Repo.get(User, user_id)
    do
      socket |> assign(:user, user)
    else
      _ -> socket
    end
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    socket = socket
    |> assign(:uri, URI.parse(uri))

    {:noreply, socket}
  end

end
