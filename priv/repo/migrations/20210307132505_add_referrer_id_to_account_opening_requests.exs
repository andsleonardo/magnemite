defmodule Magnemite.Repo.Migrations.AddReferrerIdToAccountOpeningRequests do
  use Ecto.Migration

  def change do
    alter table(:account_opening_requests) do
      add :referrer_id, references(:customers, type: :uuid)
    end
  end
end
