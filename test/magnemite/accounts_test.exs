defmodule Magnemite.AccountsTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Accounts
  alias Magnemite.Accounts.AccountOpeningRequest

  describe "list_complete_account_opening_requests/1" do
    test "lists the records with complete status that matches referrer_id" do
      %{id: account_opening_request_id, referrer_id: referrer_id} =
        insert(:complete_account_opening_request)

      assert [%{id: ^account_opening_request_id}] =
               Accounts.list_complete_account_opening_requests(referrer_id)
    end

    test "returns an empty array when all records matching referrer_id have pending status" do
      %{referrer_id: referrer_id} = insert(:pending_account_opening_request)

      assert [] = Accounts.list_complete_account_opening_requests(referrer_id)
    end

    test "returns an empty array when no record matches referrer_id" do
      insert(:complete_account_opening_request)
      another_referrer_id = Ecto.UUID.generate()

      assert [] = Accounts.list_complete_account_opening_requests(another_referrer_id)
    end
  end

  describe "request_account_opening/2" do
    test """
    inserts an account opening request
    when there is a profile matching the given profile_id
    """ do
      %{id: profile_id} = insert(:profile)

      assert {:ok, %AccountOpeningRequest{profile_id: ^profile_id}} =
               Accounts.request_account_opening(profile_id)
    end

    test """
    inserts and account opening request with a profile_id and a referrer_id
    when both of these ids match existing records
    """ do
      %{id: profile_id} = insert(:profile)
      %{id: referrer_id} = insert(:profile)

      assert {:ok, %AccountOpeningRequest{profile_id: ^profile_id, referrer_id: ^referrer_id}} =
               Accounts.request_account_opening(profile_id, referrer_id)
    end

    test """
    returns an error when trying to create an account opening request
    with a profile_id that does not match any record
    """ do
      assert {:error, :changeset, %{profile: ["does not exist"]}} =
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
