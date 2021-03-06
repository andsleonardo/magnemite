defmodule Magnemite.Customers.CustomerValidatorTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.CustomerValidator

  import Magnemite.Factory

  describe "complete_customer?/1" do
    @complete_customer build(:customer)

    test "returns true when every relevant customer info is present" do
      assert CustomerValidator.complete_customer?(@complete_customer)
    end

    test "returns false when customer is missing :birth_date" do
      refute CustomerValidator.complete_customer?(%{@complete_customer | birth_date: nil})
    end

    test "returns false when customer is missing :cpf" do
      refute CustomerValidator.complete_customer?(%{@complete_customer | cpf: nil})
    end

    test "returns false when customer is missing :email" do
      refute CustomerValidator.complete_customer?(%{@complete_customer | email: nil})
    end

    test "returns false when customer is missing :gender" do
      refute CustomerValidator.complete_customer?(%{@complete_customer | gender: nil})
    end

    test "returns false when customer is missing :name" do
      refute CustomerValidator.complete_customer?(%{@complete_customer | name: nil})
    end
  end
end
