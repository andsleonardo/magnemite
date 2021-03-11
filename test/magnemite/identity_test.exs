defmodule Magnemite.IdentityTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Identity
  alias Magnemite.Identity.User

  describe "sign_up/2" do
    @user_params params_for(:user)

    test "creates a user if none exists with the given username" do
      %{username: username, password: password} = @user_params

      assert {:ok,
              %User{
                id: user_id,
                username: ^username
              } = user} = Identity.sign_up(username, password)

      assert {:ok, %User{id: ^user_id}} = Argon2.check_pass(user, password)
    end

    test "returns an error if an user with such username already exists" do
      %{username: username} = insert(:user)

      assert {:error, :changeset, %{username: ["has already been taken"]}} =
               Identity.sign_up(username, @user_params.password)
    end
  end

  describe "sign_in/2 with %User{}" do
    setup do
      %{
        user: insert(:user)
      }
    end

    test "returns the user when it matches the given password", %{
      user: %{id: user_id, password: password} = user
    } do
      assert {:ok, %User{id: ^user_id}} = Identity.sign_in(user, password)
    end

    test "returns the user with a newly created token", %{
      user: user
    } do
      assert {:ok, %User{token: user_token}} = Identity.sign_in(user, user.password)

      refute is_nil(user_token)
    end

    test "returns an error when the user doesn't match the given password", %{
      user: user
    } do
      %{password: invalid_password} = params_for(:user)

      assert {:error, :invalid_password} = Identity.sign_in(user, invalid_password)
    end
  end

  describe "sign_in/2 with username" do
    test "gets the user matching username when the given password is valid" do
      %{id: user_id} = user = insert(:user)

      assert {:ok, %User{id: ^user_id}} = Identity.sign_in(user.username, user.password)
    end

    test "returns an error when there's an user matching username, but the given password is invalid" do
      user = insert(:user)

      assert {:error, :invalid_password} = Identity.sign_in(user.username, "invalid_password")
    end

    test "returns an error when no user matches username" do
      assert {:error, :user_not_found} = Identity.sign_in("invalid_username", "some_password")
    end
  end
end
