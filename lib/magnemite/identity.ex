defmodule Magnemite.Identity do
  @moduledoc """
  Internal API for Identity.
  """

  alias __MODULE__.User
  alias Magnemite.Repo

  def sign_up(username, password) do
    create_user(username: username, password: password)
  end

  defp create_user(params) do
    %User{}
    |> User.changeset(Map.new(params))
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def sign_in(%User{} = user, password) do
    user
    |> Argon2.check_pass(password)
    |> case do
      {:error, _} -> {:error, :invalid_password}
      success -> success
    end
  end

  def sign_in(username, password) do
    with {:ok, user} <- get_user_by(username: username) do
      sign_in(user, password)
    end
  end

  defp get_user_by(criteria) do
    User
    |> Repo.get_by(criteria)
    |> case do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
