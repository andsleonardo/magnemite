defmodule MagnemiteWeb.Api.V1.CustomerView do
  @moduledoc false

  use MagnemiteWeb, :view

  alias MagnemiteWeb.Api.V1.{AddressView, ReferralCodeView}

  def render("show.json", %{customer: customer}) do
    address = render_one(customer.address, AddressView, "show_within_customer.json")

    referral_code =
      render_one(customer.referral_code, ReferralCodeView, "show_within_customer.json")

    customer
    |> Map.take([
      :birth_date,
      :cpf,
      :email,
      :gender,
      :name
    ])
    |> Map.merge(%{
      address: address,
      referral_code: referral_code
    })
  end
end
