defmodule Magnemite.Customers.Customer do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  alias Magnemite.Customers

  schema "customers" do
    field :birth_date, :date
    field :cpf
    field :email
    field :gender, {:array, Ecto.Enum}, values: Customers.GenderOptions.list()
    field :name
  end

  def changeset(customer, params) do
    customer
    |> cast(params, [:birth_date, :cpf, :email, :gender, :name])
    |> validate_required([:cpf])
  end
end
