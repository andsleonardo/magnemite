defmodule MagnemiteWeb.Api.V1.CustomerViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.{AddressView, CustomerView, ReferralCodeView}

  import Magnemite.Factory

  describe "render/2 with 'show.json'" do
    @customer build(:customer, address: build(:address), referral_code: build(:referral_code))

    test "renders an customer" do
      rendered_address =
        AddressView.render("show_within_customer.json", %{address: @customer.address})

      rendered_referral_code =
        ReferralCodeView.render("show_within_customer.json", %{
          referral_code: @customer.referral_code
        })

      rendered_customer = CustomerView.render("show.json", %{customer: @customer})

      assert rendered_customer == %{
               address: rendered_address,
               birth_date: @customer.birth_date,
               cpf: @customer.cpf,
               email: @customer.email,
               gender: @customer.gender,
               name: @customer.name,
               referral_code: rendered_referral_code
             }
    end
  end
end
