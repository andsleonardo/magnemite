defmodule Magnemite.AccountsTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Accounts
  alias Magnemite.Accounts.AccountOpeningRequest

  import Magnemite.Factory

  describe "get_or_create_account_opening_request/1" do
    test """
    inserts an account opening request
    when there is a customer matching the given customer_id
    """ do
      customer = insert(:customer)

      assert {:ok, %AccountOpeningRequest{}} =
               Accounts.get_or_create_account_opening_request(customer.id)
    end

    test """
    returns an error when trying to create an account opening request
    with a customer_id that doesn not match any customers
    """ do
      assert {:error, %{customer: ["does not exist"]}} =
               Accounts.get_or_create_account_opening_request(Ecto.UUID.generate())
    end

    test """
    raises an error when trying to create an account opening request with a nil customer_id
    """ do
      assert_raise FunctionClauseError, fn ->
        Accounts.get_or_create_account_opening_request(nil)
      end
    end
  end
end
