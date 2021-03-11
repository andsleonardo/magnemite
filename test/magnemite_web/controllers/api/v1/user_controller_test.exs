defmodule MagnemiteWeb.Api.V1.UserControllerTest do
  use MagnemiteWeb.ConnCase, async: true

  alias Magnemite

  describe "sign_up/2" do
    @valid_sign_up_params %{
      username: Faker.Internet.user_name(),
      password: Ecto.UUID.generate()
    }

    test "returns 200 and a user object when all required params are given", %{
      conn: conn
    } do
      %{username: username} = @valid_sign_up_params

      conn = sign_user_up(conn, @valid_sign_up_params)

      assert conn.status == 200

      assert %{
               "id" => _,
               "username" => ^username,
               "token" => _
             } = parsed_resp_body!(conn)
    end

    test "returns 400 and errors when required params are missing", %{
      conn: conn
    } do
      conn = sign_user_up(conn, %{})

      assert conn.status == 400

      assert %{
               "errors" => %{
                 "password" => ["can't be blank"],
                 "username" => ["can't be blank"]
               }
             } = parsed_resp_body!(conn)
    end
  end

  describe "sign_in/2" do
    @valid_sign_in_params %{
      username: Faker.Internet.user_name(),
      password: Ecto.UUID.generate()
    }

    test """
         returns 200 and a user object when all required params are given
         and they match an existing user
         """,
         %{
           conn: conn
         } do
      {:ok, %{id: user_id, username: username}} =
        Magnemite.sign_user_up(@valid_sign_in_params.username, @valid_sign_in_params.password)

      conn = sign_user_in(conn, @valid_sign_in_params)

      assert conn.status == 200

      assert %{
               "id" => ^user_id,
               "username" => ^username,
               "token" => _
             } = parsed_resp_body!(conn)
    end

    test "returns 400 and errors when required params are missing", %{
      conn: conn
    } do
      conn = sign_user_in(conn, %{})

      assert conn.status == 400

      assert %{
               "errors" => %{
                 "password" => ["can't be blank"],
                 "username" => ["can't be blank"]
               }
             } = parsed_resp_body!(conn)
    end

    test "returns 400 and errors when there's no user matching params", %{
      conn: conn
    } do
      conn = sign_user_in(conn, @valid_sign_in_params)

      assert conn.status == 400

      assert %{
               "errors" => ["user not found"]
             } = parsed_resp_body!(conn)
    end

    defp sign_user_up(conn, params) do
      post(conn, Routes.user_path(conn, :sign_up, params))
    end

    defp sign_user_in(conn, params) do
      post(conn, Routes.user_path(conn, :sign_in, params))
    end
  end
end
