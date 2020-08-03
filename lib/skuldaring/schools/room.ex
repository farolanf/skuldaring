defmodule Skuldaring.Schools.Room do
  use Ecto.Schema
  import Ecto.Changeset

  alias Skuldaring.Accounts.User
  alias Skuldaring.Schools.School

  schema "rooms" do
    field :name, :string

    belongs_to :school, School
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
  end
end
