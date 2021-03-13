defmodule MagnemiteWeb.Helpers.AccountStatusMessagesTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Helpers.AccountStatusMessages

  describe "pending_account_message/1" do
    test "renders a pending account message" do
      assert AccountStatusMessages.pending_account_message() ==
               "Please, send us your missing information to open an account."
    end
  end

  describe "complete_account_message/1" do
    test "renders a complete account message" do
      assert AccountStatusMessages.complete_account_message() ==
               "Your Magnemite account has been successfully opened!"
    end
  end
end
