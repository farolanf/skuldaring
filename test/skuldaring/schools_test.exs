defmodule Skuldaring.SchoolsTest do
  use Skuldaring.DataCase

  alias Skuldaring.Accounts
  alias Skuldaring.Schools

  def create_user do
    Accounts.create_user(%{
      account_id: "1",
      email: "a@b.c",
      username: "u",
      first_name: "f",
      last_name: "l"
    })
  end

  def create_school(user_id) do
    %{name: "school"}
    |> Map.merge(%{user_id: user_id})
    |> Schools.create_school()
  end

  describe "schools" do
    alias Skuldaring.Schools.School

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def school_fixture(attrs \\ %{}) do
      {:ok, user} = create_user()

      {:ok, school} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{user_id: user.id})
        |> Schools.create_school()

      school
    end

    test "list_schools/0 returns all schools" do
      school = school_fixture()
      assert Schools.list_schools() == [school]
    end

    test "get_school!/1 returns the school with given id" do
      school = school_fixture()
      assert Schools.get_school!(school.id) == school
    end

    test "create_school/1 with valid data creates a school" do
      {:ok, user} = create_user()

      assert {:ok, %School{} = school} = @valid_attrs
      |> Map.merge(%{user_id: user.id})
      |> Schools.create_school()

      assert school.name == "some name"
    end

    test "create_school/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_school(@invalid_attrs)
    end

    test "update_school/2 with valid data updates the school" do
      school = school_fixture()
      assert {:ok, %School{} = school} = Schools.update_school(school, @update_attrs)
      assert school.name == "some updated name"
    end

    test "update_school/2 with invalid data returns error changeset" do
      school = school_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_school(school, @invalid_attrs)
      assert school == Schools.get_school!(school.id)
    end

    test "delete_school/1 deletes the school" do
      school = school_fixture()
      assert {:ok, %School{}} = Schools.delete_school(school)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_school!(school.id) end
    end

    test "change_school/1 returns a school changeset" do
      school = school_fixture()
      assert %Ecto.Changeset{} = Schools.change_school(school)
    end
  end

  describe "rooms" do
    alias Skuldaring.Schools.Room

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, user} = create_user()
      {:ok, school} = create_school(user.id)

      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{user_id: user.id, school_id: school.id})
        |> Schools.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Schools.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Schools.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      {:ok, user} = create_user()
      {:ok, school} = create_school(user.id)

      assert {:ok, %Room{} = room} = @valid_attrs
      |> Map.merge(%{user_id: user.id, school_id: school.id})
      |> Schools.create_room()

      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Schools.update_room(room, @update_attrs)
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_room(room, @invalid_attrs)
      assert room == Schools.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Schools.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Schools.change_room(room)
    end
  end

  describe "school_roles" do
    alias Skuldaring.Schools.SchoolRole

    @valid_attrs %{role: "some role"}
    @update_attrs %{role: "some updated role"}
    @invalid_attrs %{role: nil}

    def school_role_fixture(attrs \\ %{}) do
      {:ok, user} = create_user()
      {:ok, school} = create_school(user.id)

      {:ok, school_role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{user_id: user.id, school_id: school.id})
        |> Schools.create_school_role()

      school_role
    end

    test "list_school_roles/0 returns all school_roles" do
      school_role = school_role_fixture()
      assert Schools.list_school_roles() == [school_role]
    end

    test "get_school_role!/1 returns the school_role with given id" do
      school_role = school_role_fixture()
      assert Schools.get_school_role!(school_role.id) == school_role
    end

    test "create_school_role/1 with valid data creates a school_role" do
      {:ok, user} = create_user()
      {:ok, school} = create_school(user.id)

      assert {:ok, %SchoolRole{} = school_role} = @valid_attrs
      |> Map.merge(%{user_id: user.id, school_id: school.id})
      |> Schools.create_school_role()

      assert school_role.role == "some role"
    end

    test "create_school_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schools.create_school_role(@invalid_attrs)
    end

    test "update_school_role/2 with valid data updates the school_role" do
      school_role = school_role_fixture()
      assert {:ok, %SchoolRole{} = school_role} = Schools.update_school_role(school_role, @update_attrs)
      assert school_role.role == "some updated role"
    end

    test "update_school_role/2 with invalid data returns error changeset" do
      school_role = school_role_fixture()
      assert {:error, %Ecto.Changeset{}} = Schools.update_school_role(school_role, @invalid_attrs)
      assert school_role == Schools.get_school_role!(school_role.id)
    end

    test "delete_school_role/1 deletes the school_role" do
      school_role = school_role_fixture()
      assert {:ok, %SchoolRole{}} = Schools.delete_school_role(school_role)
      assert_raise Ecto.NoResultsError, fn -> Schools.get_school_role!(school_role.id) end
    end

    test "change_school_role/1 returns a school_role changeset" do
      school_role = school_role_fixture()
      assert %Ecto.Changeset{} = Schools.change_school_role(school_role)
    end
  end
end
