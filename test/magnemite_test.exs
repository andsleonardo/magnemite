defmodule MagnemiteTest do
  use Magnemite.DataCase, async: true

  alias Magnemite
  alias Magnemite.Customers

  describe "get_or_open_account/1" do
    @account_opening_data %{
      birth_date: Date.to_iso8601(Faker.Date.date_of_birth()),
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      email: Faker.Internet.email(),
      gender: [to_string(Enum.random(Customers.gender_options()))],
      name: Faker.Person.PtBr.name(),
      state: Faker.Address.PtBr.state()
    }

    setup do
      user = insert(:user)

      %{
        account_opening_data: %{
          valid: Map.merge(@account_opening_data, %{user_id: user.id})
        },
        user: user
      }
    end

    test """
         returns a %Magnemite.Account{} with pending status and without referral code
         when given a new valid CPF, but not all necessary account opening data
         """,
         %{
           account_opening_data: account_opening_data
         } do
      valid_account_opening_data = Map.take(account_opening_data.valid, [:cpf, :user_id])

      assert {:ok,
              %{
                status: :pending,
                referral_code: nil
              }} = Magnemite.get_or_open_account(valid_account_opening_data)
    end

    test """
         returns a %Magnemite.Account{} with complete status and referral code
         when given a new valid CPF and all necessary account opening data
         """,
         %{
           account_opening_data: account_opening_data
         } do
      assert {:ok,
              %{
                status: :complete,
                referral_code: referral_code
              }} = Magnemite.get_or_open_account(account_opening_data.valid)

      refute is_nil(referral_code)
    end

    test """
         returns a %Magnemite.Account{} with pending status and without referral code
         when given a known valid CPF, but not all necessary account opening data
         """,
         %{
           account_opening_data: account_opening_data
         } do
      valid_account_opening_data =
        Map.take(account_opening_data.valid, [:city, :cpf, :name, :user_id])

      assert {:ok,
              %{
                status: :pending,
                referral_code: nil
              }} = Magnemite.get_or_open_account(valid_account_opening_data)
    end

    test """
         returns a %Magnemite.Account{} with complete status and referral code
         when given a known valid CPF and all necessary account opening data
         """,
         %{
           account_opening_data: account_opening_data,
           user: user
         } do
      insert(:profile, cpf: account_opening_data.valid.cpf, user: user)

      assert {:ok,
              %{
                status: :complete,
                referral_code: referral_code
              }} = Magnemite.get_or_open_account(account_opening_data.valid)

      refute is_nil(referral_code)
    end
  end
end
