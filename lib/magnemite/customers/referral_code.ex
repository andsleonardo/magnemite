defmodule Magnemite.Customers.ReferralCode do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Customers, Repo}

  schema "referral_codes" do
    field :number, :string

    belongs_to :profile, Customers.Profile

    timestamps()
  end

  def changeset(referral_code, params) do
    referral_code
    |> cast(Map.new(params), [:number, :profile_id])
    |> assoc_constraint(:profile)
    |> validate_required([:number])
    |> validate_format(:number, ~r/\d{8}/)
    |> unsafe_validate_unique([:number], Repo)
    |> unsafe_validate_unique([:profile_id], Repo)
    |> unique_constraint([:number])
    |> unique_constraint([:profile_id])
  end
end
