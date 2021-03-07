defmodule Magnemite.Customers.Customer do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.{Customers, Repo}

  import Brcpfcnpj.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          address: Customers.Address.t() | none(),
          birth_date: Date.t(),
          cpf: String.t(),
          email: String.t(),
          gender: [atom()],
          name: String.t()
        }

  @email_regex ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/

  schema "customers" do
    field :birth_date, :date
    field :cpf
    field :email
    field :gender, {:array, Ecto.Enum}, values: Customers.GenderOptions.list()
    field :name

    has_one :address, Customers.Address, on_replace: :update
    has_one :referral_code, Customers.ReferralCode, on_replace: :update

    timestamps()
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
    |> validate_required([:cpf])
    |> unsafe_validate_unique([:cpf], Repo)
    |> unique_constraint([:cpf])
    |> changeset()
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
    |> changeset()
  end

  defp changeset(changeset) do
    changeset
    |> cast_assoc(:address, with: &Customers.Address.changeset/2)
    |> cast_assoc(:referral_code, with: &Customers.ReferralCode.changeset/2)
    |> validate_format(:email, @email_regex, message: "is an invalid email")
    |> validate_cpf(:cpf, message: "is an invalid CPF")
  end
end
