defmodule MagnemiteWeb.Api.V1.UserViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.UserView

  import Magnemite.Factory

  describe "render/2 with 'show.json'" do
    @user build(:user)

    test "renders a user" do
      rendered_user = UserView.render("show.json", %{user: @user})

      assert rendered_user == %{
        id: @user.id,
        username: @user.username,
        token: @user.token
      }
    end
  end
end
