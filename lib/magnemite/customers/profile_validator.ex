defmodule Magnemite.Customers.ProfileValidator do
  @moduledoc false

  alias Magnemite.Customers.Profile

  def complete?(%Profile{} = profile) do
    profile
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
