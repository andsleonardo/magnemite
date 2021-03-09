defmodule MagnemiteWeb.Api.V1.UserController.SignUpParams do
  @moduledoc false

  use Magnemite.{Changeset, Schema}

  @permitted_params [
    :username,
    :password
  ]

  @required_params @permitted_params

  embedded_schema do
    field :username
    field :password
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @permitted_params)
    |> validate_required(@required_params)
  end
end
