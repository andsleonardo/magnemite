defmodule Magnemite.Repo.Migrations.CreateAccountOpeningRequests do
  use Ecto.Migration

  def change do
    create table(:account_opening_requests, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :status, :string, null: false

      add :customer_id, references(:customers, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
