defmodule Magnemite.Accounts.AccountOpeningRequest do
  @moduledoc false

  use Magnemite.Schema

  alias Magnemite.{Accounts, Customers}

  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          status: atom(),
          customer: Customers.Customer.t(),
          customer_id: Ecto.UUID.t()
        }

  schema "account_opening_requests" do
    field :status, Ecto.Enum,
      values: Accounts.AccountOpeningRequestStatuses.list(),
      default: Accounts.AccountOpeningRequestStatuses.pending()

    belongs_to :customer, Customers.Customer, type: :binary_id

    timestamps()
  end

  def changeset(account_opening_request, params) do
    account_opening_request
    |> cast(params, [:status, :customer_id])
    |> validate_required([:customer_id])
    |> assoc_constraint(:customer)
  end
end
