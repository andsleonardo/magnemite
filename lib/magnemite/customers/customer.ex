defmodule Magnemite.Customers.Customer do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Customers, Repo}

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          address: Customers.Address.t() | none(),
          birth_date: Date.t(),
          cpf: String.t(),
          email: String.t(),
          gender: [atom()],
          name: String.t()
        }

  schema "customers" do
    field :birth_date, :date
    field :cpf
    field :email
    field :gender, {:array, Ecto.Enum}, values: Customers.GenderOptions.list()
    field :name

    has_one :address, Customers.Address, on_replace: :update
  end

  @doc """
  Specific changeset for creating new customers.
  """
  def creation_changeset(customer, params) do
    customer
    |> cast(params, [
      :birth_date,
      :cpf,
      :email,
      :gender,
      :name
    ])
    |> cast_assoc(:address, with: &Customers.Address.changeset/2)
    |> validate_required([:cpf])
    |> unsafe_validate_unique([:cpf], Repo)
    |> unique_constraint([:cpf])
  end

  @doc """
  Specific changeset for updating existing customers.
  """
  def update_changeset(customer, params) do
    customer
    |> cast(params, [
      :birth_date,
      :email,
      :gender,
      :name
    ])
    |> cast_assoc(:address, with: &Customers.Address.changeset/2)
  end
end
