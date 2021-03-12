defmodule Magnemite.Customers.ProfileValidator do
  @moduledoc false

  alias Magnemite.Customers.{Address, Profile}

  def complete?(%Profile{} = profile) do
    complete_profile_data?(profile) && complete_address_data?(profile.address)
  end

  defp complete_profile_data?(%Profile{} = profile) do
    profile
    |> complete_data?([
      :birth_date,
      :cpf,
      :email,
      :gender,
      :name
    ])
  end

  defp complete_address_data?(%Address{} = address) do
    address
    |> complete_data?([
      :city,
      :country,
      :state
    ])
  end

  defp complete_data?(record, fields) do
    record
    |> Map.take(fields)
    |> Map.values()
    |> Enum.all?(&(not is_nil(&1)))
  end
end
