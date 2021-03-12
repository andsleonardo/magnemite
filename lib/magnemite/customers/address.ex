defmodule Magnemite.Customers.Address do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.Customers

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          city: String.t(),
          country: String.t(),
          state: String.t(),
          profile_id: Ecto.UUID.t()
        }

  schema "addresses" do
    field :city
    field :country
    field :state

    belongs_to :profile, Customers.Profile

    timestamps()
  end

  def changeset(address, params) do
    address
    |> cast(params, [:city, :country, :profile_id, :state])
    |> assoc_constraint(:profile)
  end
end
