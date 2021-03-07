defmodule Magnemite.Customers.ReferralCode do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Customers, Repo}

  schema "referral_codes" do
    field :number, :string

    belongs_to :customer, Customers.Customer

    timestamps()
  end

  def changeset(referral_code, params) do
    referral_code
    |> cast(params, [:number, :customer_id])
    |> assoc_constraint(:customer)
    |> validate_required([:number])
    |> validate_format(:number, ~r/\d{8}/)
    |> unsafe_validate_unique([:number], Repo)
    |> unsafe_validate_unique([:customer_id], Repo)
    |> unique_constraint([:number])
    |> unique_constraint([:customer_id])
  end
end
