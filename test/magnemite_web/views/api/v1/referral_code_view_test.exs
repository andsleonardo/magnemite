defmodule MagnemiteWeb.Api.V1.ReferralCodeViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.ReferralCodeView

  import Magnemite.Factory

  describe "render/2 with 'show_within_customer.json'" do
    @referral_code build(:referral_code)

    test "renders the existing referral code number" do
      rendered_referral_code =
        ReferralCodeView.render("show_within_customer.json", %{referral_code: @referral_code})

      assert rendered_referral_code == @referral_code.number
    end
  end
end
