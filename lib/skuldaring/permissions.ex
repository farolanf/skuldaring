defmodule Skuldaring.Permissions do
  use GenServer

  alias Acx.Enforcer
  alias Skuldaring.Accounts.User

  defstruct [
    enforcer: nil
  ]

  @cfile "rbac.conf"
  @pfile "policy.csv"

  @name :permissions

  def allow?(sub, obj, act) do
    GenServer.call(@name, {:allow?, sub, obj, act})
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: @name)
  end

  @impl true
  def init([]) do
    __MODULE__.init
  end

  @impl true
  def init([cfile: cfile, pfile: pfile]) do
    __MODULE__.init(cfile, pfile)
  end

  @impl true
  def handle_call({:allow?, sub, obj, act}, _from, permissions) do
    {:reply, __MODULE__.allow?(permissions, sub, obj, act), permissions}
  end

  def init do
    init(@cfile, @pfile)
  end

  def init(cfile, pfile) do
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
      when is_binary(roles) and is_binary(obj) do
    Enforcer.allow?(enforcer, [roles, obj, act])
  end

  def allow?(%__MODULE__{} = struct, %User{} = user, obj, act)
      when is_binary(obj) do
    roles = ["guest"]
    |> Enum.concat(user.roles)
    |> Enum.join(",")

    allow?(struct, roles, obj, act)
  end

  def allow?(%__MODULE__{} = struct, %User{} = user, %_obj_name{} = obj, act) do
    roles = ["guest"]
    |> add_owner(user.id, obj)
    |> Enum.concat(user.roles)
    |> Enum.join(",")

    obj_type = get_obj_type(obj)

    allow?(struct, roles, obj_type, act)
  end

  defp add_owner(roles, user_id, %_name{} = obj) do
    case obj do
      %{user_id: ^user_id} -> ["owner" | roles]
      _ -> roles
    end
  end

  defp get_obj_type(%obj_name{}) do
    obj_name
    |> Module.split()
    |> List.last()
    |> String.downcase()
  end

end
