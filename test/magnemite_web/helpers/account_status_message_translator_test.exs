defmodule MagnemiteWeb.Helpers.AccountStatusMessageTranslatorTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Helpers.{
    AccountStatusMessages,
    AccountStatusMessageTranslator
  }

  describe "translate_account_status_to_message/1" do
    test "renders a message when status is :pending" do
      message = AccountStatusMessageTranslator.translate_account_status_to_message(:pending)

      assert message == AccountStatusMessages.pending_account_message()
    end

    test "renders a message when status is :complete" do
      message = AccountStatusMessageTranslator.translate_account_status_to_message(:complete)

      assert message == AccountStatusMessages.complete_account_message()
    end
  end
end
