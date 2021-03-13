defmodule Magnemite.Accounts.AccountOpeningRequest do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Accounts, Customers, Repo}

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          profile: Customers.Profile.t(),
          profile_id: Ecto.UUID.t(),
          referrer: Customers.Profile.t(),
          referrer_id: Ecto.UUID.t(),
          status: atom()
        }

  schema "account_opening_requests" do
    field :status, Ecto.Enum,
      values: Accounts.AccountOpeningRequestStatuses.list(),
      default: Accounts.AccountOpeningRequestStatuses.pending()

    belongs_to :referrer, Customers.Profile, type: :binary_id
    belongs_to :profile, Customers.Profile, type: :binary_id

    timestamps()
  end

  def changeset(account_opening_request, params) do
    account_opening_request
    |> cast(Map.new(params), [:status, :profile_id, :referrer_id])
    |> validate_required([:profile_id])
    |> assoc_constraint(:profile)
    |> assoc_constraint(:referrer)
    |> unsafe_validate_unique([:profile_id], Repo)
    |> unique_constraint([:profile_id])
  end
end
