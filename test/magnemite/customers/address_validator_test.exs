defmodule Magnemite.Customers.AddressValidatorTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers.AddressValidator

  import Magnemite.Factory

  describe "complete_address?/1" do
    @complete_address build(:address)

    test "returns true when every relevant address info is present" do
      assert AddressValidator.complete_address?(@complete_address)
    end

    test "returns false when address is missing :city" do
      refute AddressValidator.complete_address?(%{@complete_address | city: nil})
    end

    test "returns false when address is missing :country" do
      refute AddressValidator.complete_address?(%{@complete_address | country: nil})
    end

    test "returns false when address is missing :state" do
      refute AddressValidator.complete_address?(%{@complete_address | state: nil})
    end
  end
end
