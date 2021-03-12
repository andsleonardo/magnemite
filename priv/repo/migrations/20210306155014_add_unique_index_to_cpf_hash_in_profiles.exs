defmodule Magnemite.Repo.Migrations.AddUniqueIndexToCpfInProfiles do
  use Ecto.Migration

  def change do
    create unique_index(:profiles, [:cpf_hash])
  end
end
