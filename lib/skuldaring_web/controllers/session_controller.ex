defmodule SkuldaringWeb.SessionController do
  use SkuldaringWeb, :controller

  require Logger

  alias Skuldaring.Accounts

  def new(conn, params) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:skuldaring, params),
      {:ok, user} <- Accounts.verify_token(tokens["id_token"])
    do
      redirect_uri = (get_session(conn, :redirect_url) || "/") |> URI.parse()

      conn
      |> put_session(:user_id, user.id)
      |> delete_session(:redirect_url)
      |> redirect(to: redirect_uri.path)
    else
      {:error, :invalid_user, claims} ->
        user_params = %{
          account_id: claims["sub"],
          email: claims["email"],
          username: claims["preferred_username"],
          first_name: claims["given_name"],
          last_name: claims["family_name"],
          roles: ["user"]
        }

        {:ok, user} = Accounts.create_user(user_params)

        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      {:error, _from, %{body: body}} ->
        Logger.error body
        conn
        |> put_flash(:error, "Login failed")
        |> redirect(to: "/")
      _ -> conn
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
