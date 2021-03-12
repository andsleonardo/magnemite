defmodule Magnemite.Customers.ProfileValidatorTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.ProfileValidator

  import Magnemite.Factory

  describe "complete?/1" do
    @complete_profile build(:complete_profile)

    test "returns true when every relevant profile info is present" do
      assert ProfileValidator.complete?(@complete_profile)
    end

    test "returns false when profile is missing :birth_date" do
      refute ProfileValidator.complete?(%{@complete_profile | birth_date: nil})
    end

    test "returns false when profile is missing :cpf" do
      refute ProfileValidator.complete?(%{@complete_profile | cpf: nil})
    end

    test "returns false when profile is missing :email" do
      refute ProfileValidator.complete?(%{@complete_profile | email: nil})
    end

    test "returns false when profile is missing :gender" do
      refute ProfileValidator.complete?(%{@complete_profile | gender: nil})
    end

    test "returns false when profile is missing :name" do
      refute ProfileValidator.complete?(%{@complete_profile | name: nil})
    end
  end
end
