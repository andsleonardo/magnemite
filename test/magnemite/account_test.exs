defmodule Magnemite.AccountTest do
  use ExUnit.Case, async: true

  import Magnemite.Factory

  alias Magnemite.Account

  describe "struct" do
    @account_params %{
      customer: build(:customer),
      status: params_for(:account_opening_request).status
    }

    test "enforces :customer key" do
      params = Map.drop(@account_params, [:customer])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end

    test "enforces :status key" do
      params = Map.drop(@account_params, [:status])

      assert_raise ArgumentError, fn -> struct!(Account, params) end
    end
  end
end
