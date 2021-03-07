defmodule MagnemiteWeb.Api.V1.ReferralCodeView do
  @moduledoc false

  use MagnemiteWeb, :view

  def render("show_within_customer.json", %{referral_code: referral_code}) do
    render_referral_code_number(referral_code)
  end

  defp render_referral_code_number(nil), do: nil
  defp render_referral_code_number(referral_code), do: referral_code.number
end
