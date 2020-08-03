defmodule Skuldaring.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :name, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:schools, [:user_id])
  end
end
