defmodule MagnemiteWeb.Api.V1.AccountController.OpenAccountParamsTest do
  use ExUnit.Case, async: true

  alias Ecto.Changeset
  alias Magnemite.Customers.GenderOptions
  alias MagnemiteWeb.Api.V1.AccountController.OpenAccountParams

  import Magnemite.Changeset

  describe "embedded_schema/2" do
    test "has :birth_date and it defaults to nil" do
      assert %OpenAccountParams{birth_date: nil} = %OpenAccountParams{}
    end

    test "has :cpf and it defaults to nil" do
      assert %OpenAccountParams{cpf: nil} = %OpenAccountParams{}
    end

    test "has :city and it defaults to nil" do
      assert %OpenAccountParams{city: nil} = %OpenAccountParams{}
    end

    test "has :country and it defaults to nil" do
      assert %OpenAccountParams{country: nil} = %OpenAccountParams{}
    end

    test "has :email and it defaults to nil" do
      assert %OpenAccountParams{email: nil} = %OpenAccountParams{}
    end

    test "has :gender and it defaults to []" do
      assert %OpenAccountParams{gender: []} = %OpenAccountParams{}
    end

    test "has :name and it defaults to nil" do
      assert %OpenAccountParams{name: nil} = %OpenAccountParams{}
    end

    test "has :referral_code and it defaults to nil" do
      assert %OpenAccountParams{referral_code: nil} = %OpenAccountParams{}
    end

    test "has :state and it defaults to nil" do
      assert %OpenAccountParams{state: nil} = %OpenAccountParams{}
    end
  end

  describe "changeset/1" do
    @open_account_params %{
      birth_date: Date.to_iso8601(Faker.Date.date_of_birth()),
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      email: Faker.Internet.email(),
      gender: [to_string(Enum.random(GenderOptions.list()))],
      name: Faker.Person.PtBr.name(),
      referral_code: Nanoid.generate_non_secure(8, "12345678"),
      state: Faker.Address.PtBr.state()
    }

    test "casts :birth_date as string" do
      birth_date = @open_account_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               OpenAccountParams.changeset(%{birth_date: birth_date})
    end

    test "casts :cpf as string" do
      cpf = @open_account_params.cpf

      assert %Changeset{changes: %{cpf: ^cpf}} = OpenAccountParams.changeset(%{cpf: cpf})
    end

    test "casts :city as string" do
      city = @open_account_params.city

      assert %Changeset{changes: %{city: ^city}} = OpenAccountParams.changeset(%{city: city})
    end

    test "casts :country as string" do
      country = @open_account_params.country

      assert %Changeset{changes: %{country: ^country}} =
               OpenAccountParams.changeset(%{country: country})
    end

    test "casts :email as string" do
      email = @open_account_params.email

      assert %Changeset{changes: %{email: ^email}} = OpenAccountParams.changeset(%{email: email})
    end

    test "casts :name as string" do
      name = @open_account_params.name

      assert %Changeset{changes: %{name: ^name}} = OpenAccountParams.changeset(%{name: name})
    end

    test "casts :gender as an array of strings" do
      gender = @open_account_params.gender

      assert %Changeset{changes: %{gender: ^gender}} =
               OpenAccountParams.changeset(%{gender: gender})
    end

    test "casts :referral_code as string" do
      referral_code = @open_account_params.referral_code

      assert %Changeset{changes: %{referral_code: ^referral_code}} =
               OpenAccountParams.changeset(%{referral_code: referral_code})
    end

    test "casts :state as string" do
      state = @open_account_params.state

      assert %Changeset{changes: %{state: ^state}} = OpenAccountParams.changeset(%{state: state})
    end

    test "requires :cpf" do
      errors =
        %{cpf: nil}
        |> OpenAccountParams.changeset()
        |> errors_on(:cpf)

      assert "can't be blank" in errors
    end
  end
end
