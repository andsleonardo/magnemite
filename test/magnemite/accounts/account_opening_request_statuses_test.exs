defmodule Magnemite.Accounts.AccountOpeningRequestStatusesTest do
  use ExUnit.Case, async: true

  alias Magnemite.Accounts.AccountOpeningRequestStatuses

  describe "list/0" do
    test "returns a list of statuses" do
      assert AccountOpeningRequestStatuses.list() == [
               :done,
               :pending
             ]
    end
  end

  describe "pending/0" do
    test "returns :pending" do
      assert AccountOpeningRequestStatuses.pending() == :pending
    end
  end

  describe "done/0" do
    test "returns :done" do
      assert AccountOpeningRequestStatuses.done() == :done
    end
  end
end
