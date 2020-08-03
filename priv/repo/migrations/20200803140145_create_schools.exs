defmodule Skuldaring.Repo.Migrations.CreateSchools do
  use Ecto.Migration

  def change do
    create table(:schools) do
      add :name, :string, null: false
      add :user_id, references("users"), null: false

      timestamps()
    end

  end
end
