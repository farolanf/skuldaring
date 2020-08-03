defmodule Skuldaring.Schools.School do
  use Ecto.Schema
  import Ecto.Changeset

  alias Skuldaring.Accounts.User

  schema "schools" do
    field :name, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(school, attrs) do
    school
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
