defmodule Magnemite.Accounts.AccountOpeningRequest do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Accounts, Customers, Repo}

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          customer: Customers.Customer.t(),
          customer_id: Ecto.UUID.t(),
          referrer: Customers.Customer.t(),
          referrer_id: Ecto.UUID.t(),
          status: atom()
        }

  schema "account_opening_requests" do
    field :status, Ecto.Enum,
      values: Accounts.AccountOpeningRequestStatuses.list(),
      default: Accounts.AccountOpeningRequestStatuses.pending()

    belongs_to :referrer, Customers.Customer, type: :binary_id, source: :customer_id
    belongs_to :customer, Customers.Customer, type: :binary_id

    timestamps()
  end

  def changeset(account_opening_request, params) do
    account_opening_request
    |> cast(params, [:status, :customer_id, :referrer_id])
    |> validate_required([:customer_id])
    |> assoc_constraint(:customer)
    |> assoc_constraint(:referrer)
    |> unsafe_validate_unique([:customer_id], Repo)
    |> unique_constraint([:customer_id])
  end
end
