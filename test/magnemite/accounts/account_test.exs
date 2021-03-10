defmodule Magnemite.Accounts.AccountTest do
  use ExUnit.Case, async: true

  alias Magnemite.Accounts.Account

  describe "struct" do
    @valid_account_params %{
      referral_code: "referral_code",
      status: "status"
    }

    test "enforces :status key" do
      params = Map.drop(@valid_account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :referral_code key" do
      params = Map.drop(@valid_account_params, [:referral_code])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end
  end
end
