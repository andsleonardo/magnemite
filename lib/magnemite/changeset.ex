defmodule Magnemite.Changeset do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Ecto.Changeset

      import Changeset

      defdelegate errors_on(changeset), to: unquote(__MODULE__)
      defdelegate errors_on(changeset, field), to: unquote(__MODULE__)
    end
  end

  import Magnemite.Fallback

  @doc """
  Gets the changeset errors associated to a field.
  """
  def errors_on(%Ecto.Changeset{} = changeset, field) when is_atom(field) do
    changeset
    |> errors_on()
    |> Map.get(field)
    |> fallback_to([])
  end

  @doc """
  Transforms changeset errors into a map of messages.
  """
  def errors_on(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts
        |> Keyword.get(String.to_existing_atom(key), key)
        |> to_string()
      end)
    end)
  end
end
