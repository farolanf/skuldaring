defmodule Skuldaring.Schools.SchoolRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias Skuldaring.Accounts.User
  alias Skuldaring.Schools.School

  schema "school_roles" do
    field :role, :string

    belongs_to :school, School
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(school_role, attrs) do
    school_role
    |> cast(attrs, [:role, :school_id, :user_id])
    |> validate_required([:role, :school_id, :user_id])
    |> foreign_key_constraint(:school_id)
    |> foreign_key_constraint(:user_id)
  end
end
