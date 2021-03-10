defmodule MagnemiteWeb.Api.V1.ReferreeController do
  @moduledoc false

  use MagnemiteWeb, :controller

  alias MagnemiteWeb.Api.V1.ReferreeView

  plug MagnemiteWeb.Plugs.AssignCustomer when action in [:index]

  action_fallback MagnemiteWeb.Api.FallbackController

  @doc """
  Create or update a Magnemite referral opening request.

  * Method: POST
  * Endpoint: /api/v1/referrees
  """
  def index(%{assigns: %{customer: customer}} = conn, params) do
    with {:ok, referrees} <- Magnemite.list_referrees(customer.id) do
      json(conn, ReferreeView.render("index.json", %{referrees: referrees}))
    end
  end
end
