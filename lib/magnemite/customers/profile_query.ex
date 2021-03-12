defmodule Magnemite.Customers.ProfileQuery do
  @moduledoc false

  alias Magnemite.Customers.Profile

  import Ecto.Query

  def by_referral_code(referral_code_number) do
    Profile
    |> join(:inner, [p], rc in assoc(p, :referral_code))
    |> where([_, rc], rc.number == ^referral_code_number)
  end
end
