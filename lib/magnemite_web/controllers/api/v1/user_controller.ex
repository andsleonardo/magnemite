defmodule MagnemiteWeb.Api.V1.UserController do
  @moduledoc false

  use MagnemiteWeb, :controller

  alias __MODULE__.SignUpParams
  alias MagnemiteWeb.Api.V1.UserView

  import MagnemiteWeb.Api.Parameterizer

  action_fallback MagnemiteWeb.Api.FallbackController

  @doc """
  Registers an user.

  * Method: POST
  * Endpoint: /api/v1/users/sign_up
  """
  def sign_up(conn, params) do
    with {:ok, params} <- permit_and_require_params(params, &SignUpParams.changeset/1),
         {:ok, user} <- Magnemite.sign_user_up(params.username, params.password) do
      json(conn, render_user(user))
    end
  end

  @doc """
  Signs an user in, generating a token.

  * Method: POST
  * Endpoint: /api/v1/users/sign_in
  """
  def sign_in(conn, params) do
    with {:ok, params} <- permit_and_require_params(params, &SignUpParams.changeset/1),
         {:ok, user} <- Magnemite.sign_user_in(params.username, params.password) do
      json(conn, render_user(user))
    end
  end

  defp render_user(user) do
    UserView.render("show.json", %{user: user})
  end
end
