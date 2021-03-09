defmodule MagnemiteWeb.Api.V1.UserController.SignUpParamsTest do
  use ExUnit.Case, async: true
  use Magnemite.Changeset

  alias MagnemiteWeb.Api.V1.UserController.SignUpParams

  describe "embedded_schema/2" do
    test "has :username and it defaults to nil" do
      assert %SignUpParams{username: nil} = %SignUpParams{}
    end

    test "has :password and it defaults to nil" do
      assert %SignUpParams{password: nil} = %SignUpParams{}
    end
  end

  describe "changeset/1" do
    @sign_up_params %{
      username: Faker.Internet.user_name(),
      password: Nanoid.generate_non_secure(8, "abcdef12345")
    }

    test "casts :username as string" do
      username = @sign_up_params.username

      assert %Changeset{changes: %{username: ^username}} =
               SignUpParams.changeset(%{username: username})
    end

    test "casts :password as string" do
      password = @sign_up_params.password

      assert %Changeset{changes: %{password: ^password}} =
               SignUpParams.changeset(%{password: password})
    end
  end
end
