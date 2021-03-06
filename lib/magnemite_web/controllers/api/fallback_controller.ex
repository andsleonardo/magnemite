defmodule MagnemiteWeb.Api.FallbackController do
  use MagnemiteWeb, :controller

  def call(conn, {:error, :changeset, errors}) do
    conn
    |> put_status(:bad_request)
    |> json(render_errors(errors))
  end

  defp render_errors(errors) do
    %{
      errors: errors
    }
  end
end
