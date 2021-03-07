defmodule Magnemite.Repo.Migrations.AddUniqueIndexToCustomerIdInAccountOpeningRequests do
  use Ecto.Migration

  def change do
    create unique_index(:account_opening_requests, [:customer_id])
  end
end
