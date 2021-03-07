defmodule MagnemiteWeb.Api.V1.AccountViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.AccountView

  import Magnemite.Factory
  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  describe "render/2 with 'show.json'" do
    @account build(:account)

    test "renders a pending account" do
      rendered_account = AccountView.render("show.json", %{account: @account})

      message = translate_account_status_to_message(@account.status)

      assert rendered_account == %{
               message: message,
               referral_code: @account.referral_code,
               status: @account.status
             }
    end
  end
end
