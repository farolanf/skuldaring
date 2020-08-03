defmodule SkuldaringWeb.SessionController do
  use SkuldaringWeb, :controller

  require Logger

  alias Skuldaring.Accounts

  def new(conn, params) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:skuldaring, params),
      {:ok, user} <- Accounts.verify_token(tokens["id_token"])
    do
      conn
      |> put_session(:user_id, user.id)
      |> redirect(to: "/")
    else
      {:error, :invalid_user, claims} ->
        user_params = %{
          account_id: claims["user_id"],
          email: claims["email"],
          username: claims["preferred_username"],
          first_name: claims["given_name"],
          last_name: claims["family_name"],
        }

        {:ok, user} = Accounts.create_user(user_params)

        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      _ ->
        conn
        |> put_flash(:error, "Login failed")
        |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> redirect(to: "/")
  end

end
