defmodule MagnemiteWeb.Api.V1.AccountController do
  @moduledoc false

  use MagnemiteWeb, :controller

  alias __MODULE__.OpenAccountParams
  alias MagnemiteWeb.Api.V1.AccountView

  import MagnemiteWeb.Api.Parameterizer

  action_fallback MagnemiteWeb.Api.FallbackController

  @doc """
  Requests the opening of an account for a signed in user.

  * Method: POST
  * Endpoint: /api/v1/accounts
  """
  def open_account(%{assigns: %{user: user}} = conn, params) do
    with {:ok, params} <- permit_and_require_params(params, &OpenAccountParams.changeset/1),
         {:ok, account} <- Magnemite.get_or_open_account(user.id, params) do
      json(conn, AccountView.render("opening_request.json", %{account: account}))
    end
  end

  @doc """
  Lists the accounts created from the signed in user's referral code.

  * Method: POST
  * Endpoint: /api/v1/accounts/referred
  """
  def list_referred(%{assigns: %{user: user}} = conn, _params) do
    user.id
    |> Magnemite.list_referred_accounts()
    |> case do
      {:ok, accounts} ->
        json(conn, AccountView.render("referred.json", %{accounts: accounts}))

      {:error, reason}
      when reason in [
             :profile_not_found,
             :account_opening_request_not_found,
             :incomplete_account_opening_request
           ] ->
        send_resp(conn, 404, "You must have a successfully open account to use this feature.")

      error ->
        error
    end
  end
end
