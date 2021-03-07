defmodule Magnemite.Customers.ReferralCodeGeneratorTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers.ReferralCodeGenerator

  describe "generate_number/0" do
    test "returns an 8-digit non-sequential unique number" do
      [referral_code1, referral_code2] =
        referral_codes = [
          ReferralCodeGenerator.generate_number(),
          ReferralCodeGenerator.generate_number()
        ]

      assert Enum.all?(referral_codes, &is_binary/1)
      assert Enum.all?(referral_codes, &Regex.match?(~r/\d{8}/, &1))

      refute referral_code1 == referral_code2
    end
  end
end
