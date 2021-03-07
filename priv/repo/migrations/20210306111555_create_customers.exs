defmodule Magnemite.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :birth_date, :date
      add :cpf, :string, null: false
      add :email, :string
      add :gender, {:array, :string}
      add :name, :string

      timestamps()
    end
  end
end
