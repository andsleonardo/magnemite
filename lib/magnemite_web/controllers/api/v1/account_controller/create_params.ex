defmodule MagnemiteWeb.Api.V1.AccountController.CreateParams do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  @permitted_params [
    :birth_date,
    :cpf,
    :city,
    :country,
    :email,
    :name,
    :gender,
    :state
  ]

  @required_params [:cpf]

  embedded_schema do
    field :birth_date
    field :cpf
    field :city
    field :country
    field :email
    field :name
    field :gender, {:array, :string}, default: []
    field :state
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @permitted_params)
    |> validate_required(@required_params)
  end
end
