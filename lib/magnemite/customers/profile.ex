defmodule Magnemite.Customers.Profile do
  @moduledoc false

  use Magnemite.{Changeset, Ecto, Schema}

  alias Magnemite.{Accounts, Customers, Identity, Repo}

  import Brcpfcnpj.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          account_opening_request: Accounts.AccountOpeningRequest.t(),
          address: Customers.Address.t() | none(),
          birth_date: EncryptedDate.t(),
          cpf: EncryptedBinary.t(),
          cpf_hash: Cloak.Ecto.SHA256.t(),
          email: EncryptedBinary.t(),
          gender: [atom()],
          name: EncryptedBinary.t(),
          referral_code: Customers.ReferralCode.t(),
          user: Identity.User.t()
        }

  @email_regex ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/

  schema "profiles" do
    field :birth_date, EncryptedDate
    field :cpf, EncryptedBinary
    field :cpf_hash, Cloak.Ecto.SHA256
    field :email, EncryptedBinary
    field :gender, {:array, Ecto.Enum}, values: Customers.GenderOptions.list()
    field :name, EncryptedBinary

    has_one :account_opening_request, Accounts.AccountOpeningRequest, on_replace: :update
    has_one :address, Customers.Address, on_replace: :update
    has_one :referral_code, Customers.ReferralCode, on_replace: :update

    belongs_to :user, Identity.User

    timestamps()
  end

  @doc """
  Specific changeset for creating new customers.
  """
  def creation_changeset(profile, params) do
    profile
    |> cast(params, [
      :birth_date,
      :cpf,
      :email,
      :gender,
      :name,
      :user_id
    ])
    |> validate_required([:cpf])
    |> put_hashed_fields()
    |> unsafe_validate_unique([:cpf_hash], Repo)
    |> unique_constraint([:cpf_hash])
    |> changeset()
  end

  @doc """
  Specific changeset for updating existing customers.
  """
  def update_changeset(profile, params) do
    profile
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
    |> assoc_constraint(:user)
    |> validate_format(:email, @email_regex, message: "is an invalid email")
    |> validate_cpf(:cpf, message: "is an invalid CPF")
  end

  defp put_hashed_fields(changeset) do
    changeset
    |> put_change(:cpf_hash, get_field(changeset, :cpf))
  end
end
