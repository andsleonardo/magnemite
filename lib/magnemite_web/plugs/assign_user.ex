defmodule MagnemiteWeb.Plugs.AssignUser do
  @moduledoc false

  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    user = Guardian.Plug.current_resource(conn)
    assign(conn, :user, user)
  end
end
