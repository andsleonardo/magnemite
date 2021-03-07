defmodule MagnemiteWeb.Api.FallbackControllerTest do
  use MagnemiteWeb.ConnCase, async: true

  alias MagnemiteWeb.Api.FallbackController

  describe "call/1 with {:error, :changeset, errors}" do
    test "puts a 422 status to conn and renders errors", %{
      conn: conn
    } do
      error = {:error, :changeset, %{field: ["is invalid"]}}

      assert %Plug.Conn{status: 400} = conn = FallbackController.call(conn, error)

      assert %{
               "errors" => %{
                 "field" => ["is invalid"]
               }
             } = parsed_resp_body!(conn)
    end
  end
end