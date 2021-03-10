defmodule MagnemiteWeb.Api.V1.ReferreeView do
  @moduledoc false

  use MagnemiteWeb, :view

  def render("index.json", %{referrees: referrees}) do
    render_many(referrees, __MODULE__, "show.json")
  end

  def render("show.json", %{referree: referree}) do
    referree
    |> Map.take([
      :account_id,
      :name
    ])
  end
end
