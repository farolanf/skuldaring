defmodule Skuldaring.Permissions do

  alias Acx.Enforcer

  defstruct [
    enforcer: nil
  ]

  @cfile "rbac.conf"
  @pfile "policy.csv"

  def init do
    {:ok, enforcer} = Enforcer.init(@cfile)

    g2 = fn r, p ->
      roles = String.split r, ~r{,\s*}
      p in roles
    end

    enforcer = enforcer
    |> Enforcer.add_fun({:g2, g2})
    |> Enforcer.load_policies!(@pfile)
    |> Enforcer.load_mapping_policies!(@pfile)

    {:ok, %__MODULE__{enforcer: enforcer}}
  end

  def allow?(%__MODULE__{enforcer: enforcer}, roles, obj, act) do
    Enforcer.allow?(enforcer, [roles, obj, act])
  end

end
