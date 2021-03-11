defmodule Magnemite.Identity.UsersTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Identity.{User, Users}

  describe "get/1" do
    test "gets the user matching id when such record exists" do
      %{id: user_id} = insert(:user)

      assert {:ok, %{id: ^user_id}} = Users.get(user_id)
    end

    test "returns an error when no record matches the given id" do
      assert {:error, :user_not_found} = Users.get(Ecto.UUID.generate())
    end
  end

  describe "get_by_username/1" do
    test "gets the user matching username when such record exists" do
      %{id: user_id, username: username} = insert(:user)

      assert {:ok, %{id: ^user_id}} = Users.get_by_username(username)
    end

    test "returns an error when no record matches the given id" do
      assert {:error, :user_not_found} = Users.get_by_username("invalid_username")
    end
  end

  describe "create/1" do
    test "creates a user when all params are valid" do
      user_params = params_for(:user)

      assert {:ok, %{id: user_id}} = Users.create(user_params)
      refute is_nil(user_id)
    end

    test "returns an error when any param is invalid" do
      assert {:error, :changeset, %{}} = Users.create(%{})
    end
  end

  describe "validate_password/2" do
    setup do
      %{
        user: insert(:user)
      }
    end

    test "validates a user when there's a password match", %{
      user: %{id: user_id} = user
    } do
      assert {:ok, %User{id: ^user_id}} = Users.validate_password(user, user.password)
    end

    test "returns an error when there's not a password match", %{
      user: user
    } do
      assert {:error, :invalid_password} = Users.validate_password(user, "invalid_password")
    end
  end

  describe "assign_token/2" do
    test "returns a user with token" do
      user = build(:user)
      token = "tolkien"

      assert {:ok, %User{token: ^token}} = Users.assign_token(user, token)
    end
  end
end
