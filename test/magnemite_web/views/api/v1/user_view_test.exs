defmodule MagnemiteWeb.Api.V1.UserViewTest do
  use ExUnit.Case, async: true

  alias MagnemiteWeb.Api.V1.UserView

  import Magnemite.Factory

  describe "render/2 with 'sign_up.json'" do
    @user build(:user)

    test "renders an user after signup" do
      rendered_user = UserView.render("sign_up.json", %{user: @user})

      assert rendered_user == %{
               id: @user.id,
               username: @user.username
             }
    end
  end

  describe "render/2 with 'sign_in.json'" do
    @user build(:user)

    test "renders an user after signin" do
      rendered_user = UserView.render("sign_in.json", %{user: @user})

      assert rendered_user == %{
        id: @user.id,
        username: @user.username,
        token: @user.token
      }
    end
  end
end
