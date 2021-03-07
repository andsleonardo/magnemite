defmodule Magnemite.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :city, :string
      add :country, :string
      add :state, :string

      add :customer_id, references(:customers, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
