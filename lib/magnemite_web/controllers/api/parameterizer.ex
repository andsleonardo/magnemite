defmodule MagnemiteWeb.Api.Parameterizer do
  @moduledoc false

  import Magnemite.Changeset

  @doc """
  Permits and requires API params with a changeset function.
  """
  @spec permit_and_require_params(map(), function()) :: {:ok, map} | {:error, :changeset, map()}
  def permit_and_require_params(%{} = params, changeset_fun) when is_function(changeset_fun) do
    params
    |> changeset_fun.()
    |> case do
      %{valid?: false} = changeset -> {:error, :changeset, errors_on(changeset)}
      %{changes: changes} -> {:ok, changes}
    end
  end
end
