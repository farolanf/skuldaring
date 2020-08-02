defmodule Skuldaring.PermissionsTest do
  use Skuldaring.DataCase, async: true

  alias Skuldaring.Permissions
  alias Skuldaring.Accounts.User

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
      user = %User{id: 1, roles: ["reader"]}
      article = %Article{}
      assert Permissions.allow?(permissions, user, article, "delete") == true
    end

    test "fail on action", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "reader", "article", "update") == false
    end

    test "fail on object", %{permissions: permissions} do
      assert Permissions.allow?(permissions, "reader", "unknown_obj", "read") == false
    end

    test "fail with objects", %{permissions: permissions} do
      user = %User{id: 1, roles: ["reader"]}
      article = %Article{user_id: 2}
      assert Permissions.allow?(permissions, user, article, "delete") == false
    end

    test "guest", %{permissions: permissions} do
      user = %User{id: 100, roles: []}
      article = %Article{user_id: 1}
      assert Permissions.allow?(permissions, user, article, "read") == true
    end

  end

  describe "permissions singleton" do

    requests = [
      {"guest", "article", "read", true},
      {"reader", "article", "read", true},
      {"author", "article", "read", true},
      {"author", "article", "update", true},
      {"owner", "article", "delete", true},
      {"allow_objs", "unknown", "read", true},
      {"allow_acts", "article", "unknown", true},
      {"admin", "unknown", "unknown", true},
      {"guest", "article", "update", false}
    ]

    Enum.each(requests, fn {sub, obj, act, res} ->
      test "#{sub}, #{obj}, #{act} = #{res}" do
        assert Permissions.allow?(unquote(sub), unquote(obj), unquote(act)) == unquote(res)
      end
    end)

  end
end
