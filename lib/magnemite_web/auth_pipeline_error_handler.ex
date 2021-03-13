defmodule MagnemiteWeb.AuthPipelineErrorHandler do
  @moduledoc false

  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl true
  def auth_error(conn, {type, reason}, _opts) do
    send_resp(conn, 401, "Unauthorized")
  end
end
