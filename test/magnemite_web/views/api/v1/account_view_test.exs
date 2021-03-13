defmodule MagnemiteWeb.Api.V1.AccountViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.AccountView

  import Magnemite.Factory
  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  describe "render/2 with 'opening_request.json'" do
    @account build(:account)

    test "renders a pending account" do
      rendered_account = AccountView.render("opening_request.json", %{account: @account})

      message = translate_account_status_to_message(@account.status)

      assert rendered_account == %{
               message: message,
               referral_code: @account.referral_code,
               status: @account.status
             }
    end
  end

  describe "render/2 with 'referred.json' and a single account" do
    @account build(:account)

    test "renders a referred account" do
      rendered_account = AccountView.render("referred.json", %{account: @account})

      assert rendered_account == %{
        id: @account.id,
        name: @account.name
      }
    end
  end

  describe "render/2 with 'referred.json' and multiple accounts" do
    @accounts build_list(2, :account)

    test "renders referred accounts" do
      rendered_accounts = AccountView.render("referred.json", %{accounts: @accounts})

      [account1, account2] = @accounts

      assert rendered_accounts == %{
               accounts: [
                 %{
                   id: account1.id,
                   name: account1.name
                 },
                 %{
                   id: account2.id,
                   name: account2.name
                 }
               ]
             }
    end
  end
end
