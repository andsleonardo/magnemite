defmodule MagnemiteWeb.AuthPipelineErrorHandler do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  @behaviour Guardian.Plug.ErrorHandler

  @impl true
  def auth_error(conn, {type, reason}, _opts) do
    body = json(conn, %{errors: [to_string(type)]})
    send_resp(conn, 401, body)
  end
end
