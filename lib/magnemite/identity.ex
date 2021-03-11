defmodule Magnemite.Identity do
  @moduledoc """
  Internal API for Identity.
  """

  alias __MODULE__.{Guardian, User, Users}

  @doc """
  Registers a user and signs them in.
  """
  @spec sign_up(String.t(), String.t()) ::
          {:ok, User.t()} | {:error, any()} | {:error, :changeset, map()}
  def sign_up(username, password) do
    with {:ok, user} <- Users.create(username: username, password: password) do
      sign_in(user, user.password)
    end
  end

  @doc """
  Signs a user in.
  """
  @spec sign_in(User.t() | String.t(), String.t()) ::
          {:ok, User.t()} | {:error, any()} | {:error, :changeset, map()}
  def sign_in(%User{} = user, password) do
    with {:ok, user} <- Users.validate_password(user, password),
         {:ok, token, _} <- Guardian.encode_and_sign(user) do
      Users.assign_token(user, token)
    end
  end

  def sign_in(username, password) do
    with {:ok, user} <- Users.get_by_username(username) do
      sign_in(user, password)
    end
  end
end
