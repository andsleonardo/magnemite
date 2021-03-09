defmodule MagnemiteWeb.Api.V1.UserView do
  @moduledoc false

  use MagnemiteWeb, :view

  def render("sign_up.json", %{user: user}) do
    user
    |> Map.take([
      :id,
      :username
    ])
  end

  def render("sign_in.json", %{user: user}) do
    user
    |> Map.take([
      :id,
      :token,
      :username
    ])
  end
end
