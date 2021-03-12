defmodule Magnemite.Repo.Migrations.AddUniqueIndexToProfileIdInReferralCodes do
  use Ecto.Migration

  def change do
    create unique_index(:referral_codes, [:profile_id])
  end
end
