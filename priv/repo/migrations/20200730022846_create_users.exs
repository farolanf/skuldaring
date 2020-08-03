defmodule Skuldaring.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :account_id, :string, null: false
      add :email, :string, null: false
      add :username, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :roles, {:array, :string}, null: false, default: []

      timestamps()
    end

    create unique_index(:users, [:account_id])
    create unique_index(:users, [:email])
  end
end
