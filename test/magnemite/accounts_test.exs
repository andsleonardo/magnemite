defmodule Magnemite.AccountsTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Accounts
  alias Magnemite.Accounts.AccountOpeningRequest

  describe "request_account_opening/2" do
    test """
    inserts an account opening request
    when there is a customer matching the given customer_id
    """ do
      customer = insert(:customer)

      assert {:ok, %AccountOpeningRequest{}} = Accounts.request_account_opening(customer.id)
    end

    test """
    returns an error when trying to create an account opening request
    with a customer_id that does not match any record
    """ do
      assert {:error, :changeset, %{customer: ["does not exist"]}} =
               Accounts.request_account_opening(Ecto.UUID.generate())
    end
  end

  describe "complete_account_opening/1" do
    test "changes the status of an account_opening_request to :complete" do
      account_opening_request = insert(:pending_account_opening_request)

      assert {:ok, %AccountOpeningRequest{status: :complete}} =
               Accounts.complete_account_opening(account_opening_request)
    end

    test "output the unchanged account_opening_request when it's already complete" do
      %{id: account_opening_request_id, status: :complete} =
        account_opening_request = insert(:complete_account_opening_request)

      assert {:ok, %AccountOpeningRequest{id: ^account_opening_request_id}} =
               Accounts.complete_account_opening(account_opening_request)
    end
  end
end
