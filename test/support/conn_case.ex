defmodule MagnemiteWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use MagnemiteWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MagnemiteWeb.ConnCase

      alias MagnemiteWeb.Router.Helpers, as: Routes

      defp parsed_resp_body!(%Plug.Conn{resp_body: resp_body}) do
        Jason.decode!(resp_body)
      end

      # The default endpoint for testing
      @endpoint MagnemiteWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Magnemite.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Magnemite.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
