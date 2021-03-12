defmodule Magnemite.Customers.ReferralCodesTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers.ReferralCodes

  describe "list_numbers/0" do
    test "lists the created referral code numbers" do
      [
        %{number: number1},
        %{number: number2},
        %{number: number3}
      ] = insert_list(3, :referral_code)

      referral_codes_numbers = ReferralCodes.list_numbers()

      assert number1 in referral_codes_numbers
      assert number2 in referral_codes_numbers
      assert number3 in referral_codes_numbers
    end
  end
end
