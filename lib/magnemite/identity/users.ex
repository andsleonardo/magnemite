defmodule Magnemite.Identity.Users do
  @moduledoc false

  alias Magnemite.Identity.User
  alias Magnemite.Repo

  def get(id) do
    User
    |> Repo.get(id)
    |> case do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def get_by_username(username) do
    User
    |> Repo.get_by(username: username)
    |> case do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end

  def create(params) do
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def validate_password(%User{} = user, password) do
    user
    |> Argon2.check_pass(password)
    |> case do
      {:error, _} -> {:error, :invalid_password}
      success -> success
    end
  end

  def assign_token(%User{} = user, token) do
    user
    |> User.edit(token: token)
    |> Repo.handle_operation_result()
  end
end
