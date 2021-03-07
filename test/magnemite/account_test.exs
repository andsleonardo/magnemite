defmodule Magnemite.AccountTest do
  use ExUnit.Case, async: true

  alias Magnemite.Account

  describe "struct" do
    @valid_account_params %{
      referral_code: "referral_code",
      status: "status"
    }

    test "enforces :status key" do
      params = Map.drop(@valid_account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end
  end
end
