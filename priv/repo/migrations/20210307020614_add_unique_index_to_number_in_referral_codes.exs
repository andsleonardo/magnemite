defmodule Magnemite.Repo.Migrations.AddUniqueIndexToNumberInReferralCodes do
  use Ecto.Migration

  def change do
    create unique_index(:referral_codes, [:number])
  end
end
