defmodule Skuldaring.Repo.Migrations.AddUserAccountId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :account_id, :string, null: false
    end

    create unique_index(:users, [:account_id])
  end
end
