defmodule MagnemiteWeb.Api.V1.AddressView do
  @moduledoc false

  use MagnemiteWeb, :view

  def render("show_within_customer.json", %{address: address}) do
    address
    |> Map.take([
      :city,
      :country,
      :state
    ])
  end
end
