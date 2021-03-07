defmodule Magnemite.AccountTest do
  use ExUnit.Case, async: true

  alias Magnemite.{Account, Accounts}

  import Magnemite.Factory

  describe "struct" do
    @account_params %{
      customer: build(:customer, id: Ecto.UUID.generate()),
      referrer: build(:customer, id: Ecto.UUID.generate()),
      status: Enum.random(Accounts.account_opening_request_statuses())
    }

    test "enforces :customer key" do
      params = Map.drop(@account_params, [:customer])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :referrer_id key" do
      params = Map.drop(@account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :status key" do
      params = Map.drop(@account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end
  end
end
