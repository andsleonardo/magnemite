defmodule MagnemiteWeb.Api.V1.AccountController do
  @moduledoc false

  use MagnemiteWeb, :controller

  alias __MODULE__.CreateParams
  alias MagnemiteWeb.Api.V1.AccountView

  import MagnemiteWeb.Api.Parameterizer

  action_fallback MagnemiteWeb.Api.FallbackController

  @doc """
  Create or update a Magnemite account opening request.

  * Method: POST
  * Endpoint: /api/v1/accounts
  """
  def create(conn, params) do
    with {:ok, permitted_params} <- permit_and_require_params(params, &CreateParams.changeset/1),
         {:ok, account} <- Magnemite.get_or_open_account(permitted_params) do
      json(conn, AccountView.render("show.json", %{account: account}))
    end
  end
end
