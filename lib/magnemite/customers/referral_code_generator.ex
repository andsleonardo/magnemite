defmodule Magnemite.Customers.ReferralCodeGenerator do
  @moduledoc false

  alias Magnemite.Customers.ReferralCodes

  def generate_number do
    number = new_referral_code()

    ReferralCodes.list_numbers()
    |> Enum.member?(number)
    |> if(do: generate_number(), else: number)
  end

  defp new_referral_code do
    Nanoid.generate_non_secure(8, "123456789")
  end
end
