defmodule MagnemiteWeb.Api.V1.UserView do
  @moduledoc false

  use MagnemiteWeb, :view

  def render("show.json", %{user: user}) do
    user
    |> Map.take([
      :id,
      :token,
      :username
    ])
  end
end
