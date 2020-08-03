defmodule Skuldaring.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string, null: false
      add :user_id, references(:users), null: false

      timestamps()
    end

    create index(:rooms, [:user_id])
  end
end
