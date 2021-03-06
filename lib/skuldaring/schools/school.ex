defmodule Skuldaring.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias Skuldaring.Accounts.User
  alias Skuldaring.Schools.{Room, SchoolRole}

  schema "schools" do
    field :name, :string

    belongs_to :user, User
    has_many :rooms, Room
    has_many :school_roles, SchoolRole

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
