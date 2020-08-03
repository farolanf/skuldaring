defmodule Skuldaring.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Skuldaring.Schools.School

  schema "users" do
    field :account_id, :string
    field :email, :string
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :roles, {:array, :string}

    has_many :schools, School

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :email, :username, :first_name, :last_name, :roles])
    |> validate_required([:account_id, :email, :username, :first_name, :last_name])
    |> unique_constraint(:account_id)
    |> unique_constraint(:email)
  end
end
