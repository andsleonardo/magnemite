defmodule MagnemiteWeb.Api.FallbackController do
  use MagnemiteWeb, :controller

  def call(conn, {:error, :changeset, errors}) do
    bad_request(conn, errors)
  end

  def call(conn, {:error, error}) do
    bad_request(conn, [translate_error(error)])
  end

  defp bad_request(conn, errors) do
    conn
    |> put_status(:bad_request)
    |> json(render_errors(errors))
  end

  defp translate_error(error) when is_atom(error) do
    ~r/_/
    |> Regex.replace(Atom.to_string(error), " ")
    |> String.capitalize()
  end

  defp render_errors(errors) do
    %{
      errors: errors
    }
  end
end
