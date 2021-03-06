defmodule Magnemite.Customers.AddressValidator do
  @moduledoc false

  alias Magnemite.Customers

  def complete_address?(%Customers.Address{} = address) do
    address
    |> Map.take([
      :city,
      :country,
      :state
    ])
    |> Map.values()
    |> Enum.all?(&(not is_nil(&1)))
  end
end
