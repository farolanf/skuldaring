defmodule Skuldaring.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :account_id, :string
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :first_name, :last_name, :roles])
    |> validate_required([:email, :username, :first_name, :last_name])
  end
end
