defmodule SkuldaringWeb.Admin.SchoolController do
  use SkuldaringWeb, :controller

  alias Skuldaring.Accounts
  alias Skuldaring.Accounts.User
  alias Skuldaring.Schools
  alias Skuldaring.Schools.School

  def index(conn, _params) do
    schools = Schools.list_schools()
    render(conn, "index.html", schools: schools)
  end

  def new(conn, _params) do
    changeset = Schools.change_school(%School{})
    render(conn, "new.html", changeset: changeset, user_choices: user_choices())
  end

  def create(conn, %{"school" => school_params}) do
    case Schools.create_school(school_params) do
      {:ok, school} ->
        conn
        |> put_flash(:info, "School created successfully.")
        |> redirect(to: Routes.admin_school_path(conn, :show, school))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    render(conn, "show.html", school: school)
  end

  def edit(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    changeset = Schools.change_school(school)
    render(conn, "edit.html", school: school, changeset: changeset, user_choices: user_choices())
  end

  def update(conn, %{"id" => id, "school" => school_params}) do
    school = Schools.get_school!(id)

    case Schools.update_school(school, school_params) do
      {:ok, school} ->
        conn
        |> put_flash(:info, "School updated successfully.")
        |> redirect(to: Routes.admin_school_path(conn, :show, school))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", school: school, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    school = Schools.get_school!(id)
    {:ok, _school} = Schools.delete_school(school)

    conn
    |> put_flash(:info, "School deleted successfully.")
    |> redirect(to: Routes.admin_school_path(conn, :index))
  end

  defp user_choices do
    case Accounts.list_users() do
      [%User{}] = users ->
        Enum.map users, fn user -> {user.username, user.id} end
      _ -> []
    end
  end

end
