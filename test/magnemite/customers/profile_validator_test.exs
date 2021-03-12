defmodule Magnemite.Customers.ProfileValidatorTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.{Address, ProfileValidator}

  import Magnemite.Factory

  describe "complete?/1" do
    @complete_address build(:address)
    @complete_profile build(:complete_profile, address: @complete_address)

    test "returns true when every relevant profile info is present" do
      assert ProfileValidator.complete?(@complete_profile)
    end

    test "returns false when profile is missing :birth_date" do
      complete_profile = struct(@complete_profile, %{birth_date: nil})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :cpf" do
      complete_profile = struct(@complete_profile, %{cpf: nil})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :email" do
      complete_profile = struct(@complete_profile, %{email: nil})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :gender" do
      complete_profile = struct(@complete_profile, %{gender: nil})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :name" do
      complete_profile = struct(@complete_profile, %{name: nil})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :address" do
      complete_profile = struct(@complete_profile, %{address: %Address{}})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :city in :address" do
      complete_profile = struct(@complete_profile, %{address: %{@complete_address | city: nil}})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :country in :address" do
      complete_profile =
        struct(@complete_profile, %{address: %{@complete_address | country: nil}})

      refute ProfileValidator.complete?(complete_profile)
    end

    test "returns false when profile is missing :state in :address" do
      complete_profile = struct(@complete_profile, %{address: %{@complete_address | state: nil}})

      refute ProfileValidator.complete?(complete_profile)
    end
  end
end
