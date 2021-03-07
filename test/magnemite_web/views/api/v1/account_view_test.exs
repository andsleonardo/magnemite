defmodule MagnemiteWeb.Api.V1.AccountViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.{AccountView, CustomerView}

  import Magnemite.Factory
  import MagnemiteWeb.Helpers.AccountStatusMessageTranslator

  describe "render/2 with 'show.json'" do
    @customer build(:customer, address: build(:address), referral_code: build(:referral_code))
    @account build(:account, customer: @customer)

    test "renders a pending account" do
      rendered_customer = CustomerView.render("show.json", %{customer: @account.customer})
      rendered_account = AccountView.render("show.json", %{account: @account})

      message = translate_account_status_to_message(@account.status)

      assert rendered_account == %{
               customer: rendered_customer,
               message: message,
               status: @account.status
             }
    end
  end
end
