defmodule MagnemiteWeb.Api.V1.ReferreeViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.ReferreeView

  import Magnemite.Factory

  describe "render/2 with 'show.json'" do
    @referree build(:referree)

    test "renders a referree" do
      rendered_referree = ReferreeView.render("show.json", %{referree: @referree})

      assert rendered_referree == %{
               account_id: @referree.account_id,
               name: @referree.name
             }
    end
  end

  describe "render/2 with 'index.json'" do
    @referrees build_list(2, :referree)

    test "renders many referrees" do
      assert [_, _] = ReferreeView.render("index.json", %{referrees: @referrees})
    end
  end
end
