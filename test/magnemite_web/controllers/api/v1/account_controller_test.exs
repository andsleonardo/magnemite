defmodule MagnemiteWeb.Api.V1.AccountControllerTest do
  use MagnemiteWeb.ConnCase, async: true

  alias Magnemite.{Customers, Identity}

  import Magnemite.Factory

  describe "create/2" do
    @open_account_params %{
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      birth_date: "1993-12-30",
      email: Faker.Internet.email(),
      name: Faker.Person.PtBr.name(),
      gender: [Enum.random(Customers.GenderOptions.list())],
      state: Faker.Address.PtBr.state()
    }

    test "returns 200 and account when user is authenticated",
         %{
           conn: conn
         } do
      user = insert(:user)

      conn = conn |> authenticate_user(user) |> open_account(%{cpf: @open_account_params.cpf})

      assert conn.status == 200

      assert parsed_resp_body!(conn) == %{
               "message" => "Please, send us your missing information to open an account.",
               "referral_code" => nil,
               "status" => "pending"
             }
    end

    defp open_account(conn, params) do
      post(conn, Routes.account_path(conn, :open_account, params))
    end
  end

  describe "list_referred/2" do
    test "returns 200 and referred accounts when user is authenticated and has a profile", %{
      conn: conn
    } do
      %{user: user} = profile = insert(:profile)
      insert(:complete_account_opening_request, profile: profile)

      conn = conn |> authenticate_user(user) |> list_referred()

      assert conn.status == 200

      assert parsed_resp_body!(conn) == %{
               "accounts" => []
             }
    end

    test "returns 400 and an error when user is authenticated, but has no profile", %{
      conn: conn
    } do
      user = insert(:user)
      conn = conn |> authenticate_user(user) |> list_referred()

      assert conn.status == 404
      assert conn.resp_body == "You must have a successfully open account to use this feature."
    end

    defp list_referred(conn) do
      get(conn, Routes.account_path(conn, :list_referred))
    end
  end

  defp authenticate_user(conn, user) do
    {:ok, token, _} = Identity.Guardian.encode_and_sign(user)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", token)
  end
end
