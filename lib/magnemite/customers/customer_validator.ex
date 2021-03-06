defmodule Magnemite.Customers.CustomerValidator do
  @moduledoc false

  alias Magnemite.Customers

  def complete_customer?(%Customers.Customer{} = customer) do
    customer
    |> Map.take([
      :birth_date,
      :cpf,
      :email,
      :gender,
      :name
    ])
    |> Map.values()
    |> Enum.all?(&(not is_nil(&1)))
  end
end
