defmodule Magnemite.Accounts.AccountOpeningRequestsTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Accounts.{
    Account,
    AccountOpeningRequest,
    AccountOpeningRequests
  }

  describe "list_done_by_referrer_id/1" do
    test "lists complete requests matching referrer_id" do
      %{id: account_opening_request_id, referrer_id: referrer_id} =
        insert(:complete_account_opening_request)

      assert [%{id: ^account_opening_request_id}] =
               AccountOpeningRequests.list_done_by_referrer_id(referrer_id)
    end

    test "returns an empty list when all requests matching referrer_id are pending" do
      %{referrer_id: referrer_id} = insert(:pending_account_opening_request)

      assert [] = AccountOpeningRequests.list_done_by_referrer_id(referrer_id)
    end

    test "returns an empty array when no request matches referrer_id" do
      insert(:complete_account_opening_request)
      another_referrer_id = Ecto.UUID.generate()

      assert [] = AccountOpeningRequests.list_done_by_referrer_id(another_referrer_id)
    end
  end

  describe "get_by_profile_id/1" do
    test "gets the account opening request matching profile_id" do
      %{id: account_opening_request_id, profile: profile} = insert(:account_opening_request)

      assert {:ok, %AccountOpeningRequest{id: ^account_opening_request_id}} =
               AccountOpeningRequests.get_by_profile_id(profile.id)
    end

    test "returns an error when no account opening request matches profile_id" do
      assert {:error, :account_opening_request_not_found} =
               AccountOpeningRequests.get_by_profile_id(Ecto.UUID.generate())
    end
  end

  describe "get_or_create/2" do
    test "gets an account opening request matching profile_id when it exists" do
      %{id: account_opening_request, profile: %{id: profile_id}} =
        insert(:account_opening_request)

      assert {:ok, %AccountOpeningRequest{id: ^account_opening_request}} =
               AccountOpeningRequests.get_or_create(profile_id)
    end

    test "creates a pending account opening request for a profile with a referrer" do
      %{id: profile_id} = insert(:profile)

      assert {:ok, %AccountOpeningRequest{status: :pending}} =
               AccountOpeningRequests.get_or_create(profile_id)
    end

    test "creates an account opening request for a profile with a referrer" do
      %{id: profile_id} = insert(:profile)
      %{id: referrer_id} = insert(:profile)

      assert {:ok, %AccountOpeningRequest{profile_id: ^profile_id, referrer_id: ^referrer_id}} =
               AccountOpeningRequests.get_or_create(profile_id, referrer_id)
    end

    test "creates an account opening request for a profile without a referrer" do
      %{id: profile_id} = insert(:profile)

      assert {:ok, %AccountOpeningRequest{profile_id: ^profile_id, referrer_id: nil}} =
               AccountOpeningRequests.get_or_create(profile_id)
    end
  end

  describe "complete?/1" do
    test "returns true when account opening request's status is :done" do
      assert AccountOpeningRequests.complete?(%AccountOpeningRequest{status: :done})
    end

    test "returns false when account opening request's status is :pending" do
      refute AccountOpeningRequests.complete?(%AccountOpeningRequest{status: :pending})
    end
  end

  describe "complete/1" do
    test "changes the status of an account opening request to :done" do
      account_opening_request = insert(:pending_account_opening_request)

      assert {:ok, %AccountOpeningRequest{status: :done}} =
               AccountOpeningRequests.complete(account_opening_request)
    end

    test "leaves a complete account opening request unchanged" do
      %{status: :done} = account_opening_request = insert(:complete_account_opening_request)

      assert {:ok, %AccountOpeningRequest{status: :done}} =
               AccountOpeningRequests.complete(account_opening_request)
    end
  end

  describe "to_account/1" do
    test "transforms an account opening request into an account" do
      %{profile: profile} = referral_code = insert(:referral_code)
      account_opening_request = insert(:complete_account_opening_request, profile: profile)

      account = AccountOpeningRequests.to_account(account_opening_request)

      assert account == %Account{
               id: account_opening_request.id,
               name: profile.name,
               referral_code: referral_code.number,
               status: account_opening_request.status
             }
    end
  end
end
