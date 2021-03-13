defmodule Magnemite.Accounts.AccountTest do
  use ExUnit.Case, async: true

  alias Magnemite.Accounts.{Account, AccountOpeningRequestStatuses}

  describe "struct" do
    @valid_account_params %{
      id: Ecto.UUID.generate(),
      name: Faker.Person.PtBr.name(),
      status: Enum.random(AccountOpeningRequestStatuses.list())
    }

    test "enforces :id key" do
      params = Map.drop(@valid_account_params, [:id])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :name key" do
      params = Map.drop(@valid_account_params, [:name])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :status key" do
      params = Map.drop(@valid_account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end
  end
end
