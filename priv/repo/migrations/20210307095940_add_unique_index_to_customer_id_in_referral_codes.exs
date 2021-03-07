defmodule Magnemite.Repo.Migrations.AddUniqueIndexToCustomerIdInReferralCodes do
  use Ecto.Migration

  def change do
    create unique_index(:referral_codes, [:customer_id])
  end
end
