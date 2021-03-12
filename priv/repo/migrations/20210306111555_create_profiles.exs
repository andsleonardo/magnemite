defmodule Magnemite.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :birth_date, :binary
      add :cpf, :binary, null: false
      add :cpf_hash, :binary, null: false
      add :email, :binary
      add :gender, {:array, :string}
      add :name, :binary

      timestamps()
    end
  end
end
