defmodule Magnemite.CustomersTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers
  alias Magnemite.Customers.Profile

  describe "get_referrer/1" do
    setup do
      %{
        profile: insert(:profile)
      }
    end

    test "returns the profile having the given referral code number", %{
      profile: %{id: profile_id} = profile
    } do
      referral_code = insert(:referral_code, profile: profile)

      assert {:ok, %Profile{id: ^profile_id}} = Customers.get_referrer(referral_code.number)
    end

    test "returns an error when there is no profile with the given referral code" do
      assert {:error, :invalid_referral_code} = Customers.get_referrer("12345678")
    end
  end
end
