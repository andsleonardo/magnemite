defmodule Magnemite.Identity.UserTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Identity.User

  describe "schema/2" do
    test "has :username and it defaults to nil" do
      assert %User{username: nil} = %User{}
    end

    test "has :password and it defaults to nil" do
      assert %User{password: nil} = %User{}
    end

    test "has :encrypted_password and it defaults to nil" do
      assert %User{encrypted_password: nil} = %User{}
    end

    test "has :customer association" do
      assert %User{customer: %Ecto.Association.NotLoaded{}} = %User{}
    end

    test "has timestamps" do
      assert %User{inserted_at: _, updated_at: _} = %User{}
    end
  end

  describe "changeset/2" do
    @user_params params_for(:user)

    test "casts :username" do
      username = @user_params.username

      assert %Changeset{changes: %{username: ^username}} =
               User.changeset(%User{}, %{username: username})
    end

    test "casts :password" do
      password = @user_params.password

      assert %Changeset{changes: %{password: ^password}} =
               User.changeset(%User{}, %{password: password})
    end

    test "puts hashed password to :encrypted_password" do
      password = @user_params.password

      assert %Changeset{changes: %{encrypted_password: encrypted_password}} =
               User.changeset(%User{}, %{password: password})

      assert is_binary(encrypted_password)
    end

    test "invalidates a non-unique :username" do
      existing_user = insert(:user)

      errors =
        %User{}
        |> User.changeset(%{username: existing_user.username})
        |> errors_on(:username)

      assert "has already been taken" in errors
    end
  end
end