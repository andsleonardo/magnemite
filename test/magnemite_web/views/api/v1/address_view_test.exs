defmodule MagnemiteWeb.Api.V1.AddressViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.AddressView

  import Magnemite.Factory

  describe "render/2 with 'show_within_customer.json'" do
    @address build(:address)

    test "renders an address" do
      rendered_address = AddressView.render("show_within_customer.json", %{address: @address})

      assert rendered_address == %{
               city: @address.city,
               country: @address.country,
               state: @address.state
             }
    end
  end
end
