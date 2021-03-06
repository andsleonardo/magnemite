defmodule Magnemite.Repo.Migrations.CreateReferralCodes do
  use Ecto.Migration

  def change do
    create table(:referral_codes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :number, :string, null: false

      add :profile_id, references(:profiles, type: :uuid, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
