defmodule Magnemite.Customers.Address do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.Customers

  schema "addresses" do
    field :city
    field :country
    field :state

    belongs_to :customer, Customers.Customer
  end

  def changeset(address, params) do
    address
    |> cast(params, [:city, :country, :customer_id, :state])
    |> assoc_constraint(:customer)
  end
end
