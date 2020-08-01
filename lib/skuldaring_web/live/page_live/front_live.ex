defmodule SkuldaringWeb.PageLive.FrontLive do
  use SkuldaringWeb, :live_view

  require Logger

  alias Skuldaring.{Repo, Accounts.User}

  @impl true
  def mount(_params, session, socket) do
    Logger.debug "live session = #{inspect session}"
    socket = case session["user_id"] do
      nil -> socket
      user_id ->
        socket
        |> assign_new(:user, fn -> Repo.get(User, user_id) end)
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
