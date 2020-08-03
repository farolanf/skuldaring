defmodule SkuldaringWeb.SessionController do
  use SkuldaringWeb, :controller

  require Logger

  alias Ecto.Changeset
  alias Skuldaring.Repo
  alias Skuldaring.Accounts.User

  def new(conn, params) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:skuldaring, params),
        {:ok, claims} <- OpenIDConnect.verify(:skuldaring, tokens["id_token"]) do
      Logger.debug "claims = #{inspect claims}"

      case Repo.get_by(User, account_id: claims["user_id"]) do
        %User{} = user ->
          conn
          |> put_session(:user_id, user.id)
          |> redirect(to: "/")
        nil ->
          user_params = %{
            email: claims["email"],
            username: claims["preferred_username"],
            first_name: claims["given_name"],
            last_name: claims["family_name"],
          }

          {:ok, user} = %User{}
          |> User.changeset(user_params)
          |> Changeset.put_change(:account_id, claims["user_id"])
          |> Repo.insert()

          conn
          |> put_session(:user_id, user.id)
          |> redirect(to: "/")
        _ ->
          conn
          |> put_flash(:error, "Login failed")
          |> redirect(to: "/")
      end
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: "/")
  end

end
