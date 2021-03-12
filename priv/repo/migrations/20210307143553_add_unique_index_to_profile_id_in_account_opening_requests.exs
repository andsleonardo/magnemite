defmodule Magnemite.Repo.Migrations.AddUniqueIndexToProfileIdInAccountOpeningRequests do
  use Ecto.Migration

  def change do
    create unique_index(:account_opening_requests, [:profile_id])
  end
end
