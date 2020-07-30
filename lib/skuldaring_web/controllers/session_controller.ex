defmodule SkuldaringWeb.SessionController do
  use SkuldaringWeb, :controller

  import Phoenix.LiveView.Controller

  alias Skuldaring.Repo
  alias Skuldaring.Accounts.User

  def new(conn, params) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:skuldaring, params),
        {:ok, claims} <- OpenIDConnect.verify(:skuldaring, tokens["id_token"]) do
      IO.inspect claims, label: "claims"

      case Repo.get_by(User, email: claims["email"]) do
        %User{} = user ->
          IO.puts "user found"
          live_render conn, SkuldaringWeb.PageLive.FrontLive, session: %{
            "user" => user
          }
        nil ->
          user_params = %{
            email: claims["email"],
            username: claims["preferred_username"],
            first_name: claims["given_name"],
            last_name: claims["family_name"],
          }

          {:ok, user} = %User{}
          |> User.changeset(user_params)
          |> Repo.insert()

          IO.puts "user created"

          live_render conn, SkuldaringWeb.PageLive.FrontLive, session: %{
            "user" => user
          }
        _ ->
          conn
          |> put_flash(:error, "Login failed")
          |> redirect(to: "/")
      end

    end
  end

end
