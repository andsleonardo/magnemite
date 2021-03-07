defmodule Magnemite.Customers.ReferralCodeGenerator do
  @moduledoc false

  alias Magnemite.Customers

  def generate_number do
    new_referral_code = new_referral_code()

    if new_referral_code in persisted_referral_codes() do
      generate_number()
    else
      new_referral_code
    end
  end

  defp new_referral_code do
    Nanoid.generate_non_secure(8, "123456789")
  end

  defp persisted_referral_codes do
    Customers.list_referral_codes_numbers()
  end
end
