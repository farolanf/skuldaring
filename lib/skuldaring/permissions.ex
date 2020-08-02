defmodule Skuldaring.Permissions do

  alias Acx.Enforcer
  alias Skuldaring.Accounts.User

  defstruct [
    enforcer: nil
  ]

  @cfile "rbac.conf"
  @pfile "policy.csv"

  def init(cfile \\ @cfile, pfile \\ @pfile) do
    {:ok, enforcer} = Enforcer.init(cfile)

    g2 = fn r, p ->
      roles = String.split r, ~r{,\s*}
      "root" in roles || p in roles
    end

    enforcer = enforcer
    |> Enforcer.add_fun({:g2, g2})
    |> Enforcer.load_policies!(pfile)
    |> Enforcer.load_mapping_policies!(pfile)

    {:ok, %__MODULE__{enforcer: enforcer}}
  end

  def allow?(%__MODULE__{enforcer: enforcer}, roles, obj, act)
      when is_binary(roles)
      when is_binary(obj) do
    Enforcer.allow?(enforcer, [roles, obj, act])
  end

  def allow?(%__MODULE__{} = struct, %User{} = user, %_obj_name{} = obj, act) do
    add_owner = fn roles ->
      user_id = user.id
      case obj do
        %{user_id: ^user_id} -> ["owner" | roles]
        _ -> roles
      end
    end

    roles = ["guest"]
    |> add_owner.()
    |> Enum.concat(user.roles)
    |> Enum.join(",")

    obj_type = get_obj_type(obj)

    allow?(struct, roles, obj_type, act)
  end

  defp get_obj_type(%obj_name{}) do
    obj_name
    |> Module.split()
    |> List.last()
    |> String.downcase()
  end

end
