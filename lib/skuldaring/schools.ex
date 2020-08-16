defmodule Skuldaring.Schools do
  @moduledoc """
  The Schools context.
  """

  import Ecto.Query, warn: false

  alias Skuldaring.Utils
  alias Skuldaring.Repo
  alias Skuldaring.Schools.School

  @doc """
  Returns the list of schools.

  ## Examples

      iex> list_schools()
      [%School{}, ...]

  """
  def list_schools(%{} = params \\ %{}) do
    School
    |> Utils.find_query(params)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single school.

  Raises `Ecto.NoResultsError` if the School does not exist.

  ## Examples

      iex> get_school!(123)
      %School{}

      iex> get_school!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school!(id), do: School |> Repo.get!(id) |> Repo.preload(:user)

  @doc """
  Creates a school.

  ## Examples

      iex> create_school(%{field: value})
      {:ok, %School{}}

      iex> create_school(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_school(attrs, changes) do
    %School{}
    |> School.changeset(attrs, changes)
    |> Repo.insert()
  end

  @doc """
  Updates a school.

  ## Examples

      iex> update_school(school, %{field: new_value})
      {:ok, %School{}}

      iex> update_school(school, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school(%School{} = school, attrs, changes) do
    school
    |> School.changeset(attrs, changes)
    |> Repo.update()
  end

  @doc """
  Deletes a school.

  ## Examples

      iex> delete_school(school)
      {:ok, %School{}}

      iex> delete_school(school)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school(%School{} = school) do
    Repo.delete(school)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school changes.

  ## Examples

      iex> change_school(school)
      %Ecto.Changeset{data: %School{}}

  """
  def change_school(%School{} = school, attrs \\ %{}, changes \\ %{}) do
    School.changeset(school, attrs, changes)
  end

  alias Skuldaring.Schools.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms(%{} = params \\ %{}) do
    Room
    |> Utils.find_query(params)
    |> Repo.all()
    |> Repo.preload([:school, :user])
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs, changes) do
    %Room{}
    |> Room.changeset(attrs, changes)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs, changes) do
    room
    |> Room.changeset(attrs, changes)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}, changes \\ %{}) do
    Room.changeset(room, attrs, changes)
  end

  alias Skuldaring.Schools.SchoolRole

  @doc """
  Returns the list of school_roles.

  ## Examples

      iex> list_school_roles()
      [%SchoolRole{}, ...]

  """
  def list_school_roles do
    Repo.all(SchoolRole)
  end

  @doc """
  Gets a single school_role.

  Raises `Ecto.NoResultsError` if the School role does not exist.

  ## Examples

      iex> get_school_role!(123)
      %SchoolRole{}

      iex> get_school_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_school_role!(id), do: Repo.get!(SchoolRole, id)

  @doc """
  Creates a school_role.

  ## Examples

      iex> create_school_role(%{field: value})
      {:ok, %SchoolRole{}}

      iex> create_school_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_school_role(attrs \\ %{}) do
    %SchoolRole{}
    |> SchoolRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a school_role.

  ## Examples

      iex> update_school_role(school_role, %{field: new_value})
      {:ok, %SchoolRole{}}

      iex> update_school_role(school_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_school_role(%SchoolRole{} = school_role, attrs) do
    school_role
    |> SchoolRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a school_role.

  ## Examples

      iex> delete_school_role(school_role)
      {:ok, %SchoolRole{}}

      iex> delete_school_role(school_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_school_role(%SchoolRole{} = school_role) do
    Repo.delete(school_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking school_role changes.

  ## Examples

      iex> change_school_role(school_role)
      %Ecto.Changeset{data: %SchoolRole{}}

  """
  def change_school_role(%SchoolRole{} = school_role, attrs \\ %{}) do
    SchoolRole.changeset(school_role, attrs)
  end
end
