defmodule MagnemiteWeb.Api.V1.AccountController.CreateParamsTest do
  use ExUnit.Case, async: true

  alias Ecto.Changeset
  alias Magnemite.Customers
  alias MagnemiteWeb.Api.V1.AccountController.CreateParams

  import Magnemite.Changeset

  describe "embedded_schema/2" do
    test "has :birth_date and it defaults to nil" do
      assert %CreateParams{birth_date: nil} = %CreateParams{}
    end

    test "has :cpf and it defaults to nil" do
      assert %CreateParams{cpf: nil} = %CreateParams{}
    end

    test "has :city and it defaults to nil" do
      assert %CreateParams{city: nil} = %CreateParams{}
    end

    test "has :country and it defaults to nil" do
      assert %CreateParams{country: nil} = %CreateParams{}
    end

    test "has :email and it defaults to nil" do
      assert %CreateParams{email: nil} = %CreateParams{}
    end

    test "has :gender and it defaults to []" do
      assert %CreateParams{gender: []} = %CreateParams{}
    end

    test "has :name and it defaults to nil" do
      assert %CreateParams{name: nil} = %CreateParams{}
    end

    test "has :state and it defaults to nil" do
      assert %CreateParams{state: nil} = %CreateParams{}
    end
  end

  describe "changeset/1" do
    @create_params %{
      birth_date: Date.to_iso8601(Faker.Date.date_of_birth()),
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      email: Faker.Internet.email(),
      gender: [to_string(Enum.random(Customers.gender_options()))],
      name: Faker.Person.PtBr.name(),
      state: Faker.Address.PtBr.state()
    }

    test "casts :birth_date as string" do
      birth_date = @create_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               CreateParams.changeset(%{birth_date: birth_date})
    end

    test "casts :cpf as string" do
      cpf = @create_params.cpf

      assert %Changeset{changes: %{cpf: ^cpf}} = CreateParams.changeset(%{cpf: cpf})
    end

    test "casts :city as string" do
      city = @create_params.city

      assert %Changeset{changes: %{city: ^city}} = CreateParams.changeset(%{city: city})
    end

    test "casts :country as string" do
      country = @create_params.country

      assert %Changeset{changes: %{country: ^country}} =
               CreateParams.changeset(%{country: country})
    end

    test "casts :email as string" do
      email = @create_params.email

      assert %Changeset{changes: %{email: ^email}} = CreateParams.changeset(%{email: email})
    end

    test "casts :name as string" do
      name = @create_params.name

      assert %Changeset{changes: %{name: ^name}} = CreateParams.changeset(%{name: name})
    end

    test "casts :gender as an array of strings" do
      gender = @create_params.gender

      assert %Changeset{changes: %{gender: ^gender}} = CreateParams.changeset(%{gender: gender})
    end

    test "casts :state as string" do
      state = @create_params.state

      assert %Changeset{changes: %{state: ^state}} = CreateParams.changeset(%{state: state})
    end

    test "requires :cpf" do
      errors =
        %{cpf: nil}
        |> CreateParams.changeset()
        |> errors_on(:cpf)

      assert "can't be blank" in errors
    end
  end
end
