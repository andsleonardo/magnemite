defmodule Magnemite.Customers.ReferreeTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.Referree

  describe "struct" do
    @valid_referree_params %{
      account_id: Ecto.UUID.generate(),
      name: Faker.Person.PtBr.name()
    }

    test "enforces :account_id key" do
      params = Map.drop(@valid_referree_params, [:account_id])

      assert_raise ArgumentError, fn -> struct!(Referree, params) end
    end

    test "enforces :name key" do
      params = Map.drop(@valid_referree_params, [:name])

      assert_raise ArgumentError, fn -> struct!(Referree, params) end
    end
  end
end
