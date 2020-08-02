defmodule Skuldaring.PermissionsTest do
  use Skuldaring.DataCase, async: true

  alias Acx.Enforcer
  alias Skuldaring.Permissions

  describe "enforcer" do

    @cfile "test/data/rbac.conf"
    @pfile "test/data/policy.csv"

    setup do
      {:ok, enforcer} = Enforcer.init(@cfile)

      g2 = fn r, p ->
        roles = String.split r, ~r{,\s*}
        p in roles
      end

      enforcer = enforcer
      |> Enforcer.add_fun({:g2, g2})
      |> Enforcer.load_policies!(@pfile)
      |> Enforcer.load_mapping_policies!(@pfile)

      %{enforcer: enforcer}
    end

    test "direct role", %{enforcer: enforcer} do
      assert Enforcer.allow?(enforcer, ["reader", "article", "read"]) == true
    end

    test "indirect role", %{enforcer: enforcer} do
      assert Enforcer.allow?(enforcer, ["admin", "article", "read"]) == true
    end

    test "multiple roles", %{enforcer: enforcer} do
      assert Enforcer.allow?(enforcer, ["reader,owner", "article", "delete"]) == true
    end

  end

  describe "permissions" do

    setup do
      {:ok, permissions} = Permissions.init
      %{permissions: permissions}
    end

    test "allow?/4", %{permissions: permissions} do
      Permissions.allow?(permissions, "reader,owner", "article", "delete")
    end

  end

end
