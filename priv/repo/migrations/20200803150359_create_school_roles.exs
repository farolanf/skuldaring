defmodule Skuldaring.Repo.Migrations.CreateSchoolRoles do
  use Ecto.Migration

  def change do
    create table(:school_roles) do
      add :role, :string, null: false
      add :school_id, references(:schools, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:school_roles, [:school_id])
    create index(:school_roles, [:user_id])
  end
end
