defmodule Magnemite.Repo.Migrations.AddUniqueIndexToCpfInCustomers do
  use Ecto.Migration

  def change do
    create unique_index(:customers, [:cpf])
  end
end
