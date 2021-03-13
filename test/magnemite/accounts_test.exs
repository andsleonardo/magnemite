defmodule Magnemite.AccountsTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Accounts
  alias Magnemite.Accounts.Account

  describe "list_complete_referred_accounts/1" do
    test "lists accounts with complete opening requests from a referrer" do
      %{id: referrer_id} = referrer = insert(:profile)

      %{id: account_opening_request1_id} =
        insert(:complete_account_opening_request, referrer: referrer)

      %{id: account_opening_request2_id} =
        insert(:complete_account_opening_request, referrer: referrer)

      assert [%Account{}, %Account{}] =
               accounts = Accounts.list_complete_referred_accounts(referrer_id)

      accounts_ids = Enum.map(accounts, & &1.id)

      assert account_opening_request1_id in accounts_ids
      assert account_opening_request2_id in accounts_ids
    end

    test "returns an empty list when all referred account opening requests are pending" do
      %{referrer_id: referrer_id} = insert(:pending_account_opening_request)

      assert [] = Accounts.list_complete_referred_accounts(referrer_id)
    end

    test "returns an empty list when there are no referred account opening requests" do
      insert(:complete_account_opening_request)
      another_referrer_id = Ecto.UUID.generate()

      assert [] = Accounts.list_complete_referred_accounts(another_referrer_id)
    end
  end
end
