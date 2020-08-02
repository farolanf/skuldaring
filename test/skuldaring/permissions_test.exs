defmodule Skuldaring.PermissionsTest do
  use Skuldaring.DataCase, async: true

  alias Acx.Enforcer
  alias Skuldaring.Permissions

  defmodule User do
    defstruct [
      id: 1
    ]
  end

  defmodule Article do
    defstruct [
      user_id: 1
    ]
  end

  @cfile "test/data/rbac.conf"
  @pfile "test/data/policy.csv"

  describe "permissions" do

    setup do
      {:ok, permissions} = Permissions.init(@cfile, @pfile)
      %{permissions: permissions}
    end

    test "direct role", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "reader", "article", "read") == true
    end

    test "indirect role", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "author", "article", "read") == true
    end

    test "multiple roles", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "reader,author", "article", "update") == true
    end

    test "* objects", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "allow_objs", "unknown_obj", "read") == true
    end

    test "* actions", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "allow_acts", "article", "unknown_act") == true
    end

    test "owner role", %{permissions: permissions} do
      user = %User{}
      article = %Article{}
      IO.inspect user, label: "user"
      IO.inspect article, label: "article"
      assert Permissions.allow?(permissions, user, article, "delete") == true
    end

  end

end
