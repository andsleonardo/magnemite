defmodule Magnemite.Identity.User do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Customers, Repo}

  @min_username_length 3
  @max_username_length 13

  schema "users" do
    field :encrypted_password
    field :password, :string, virtual: true
    field :token, :string, virtual: true
    field :username

    has_one :customer, Customers.Customer, on_replace: :update

    timestamps()
  end

  def changeset(user, params) do
    user
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> unsafe_validate_unique([:username], Repo)
    |> unique_constraint([:username])
    |> encrypt_password()
  end

  defp encrypt_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    encrypted_password =
      password
      |> Argon2.add_hash()
      |> Map.get(:password_hash)

    put_change(changeset, :encrypted_password, encrypted_password)
  end

  defp encrypt_password(changeset), do: changeset
end
