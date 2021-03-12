defmodule Magnemite.Repo.Migrations.AddUserIdToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
    end
  end
end
