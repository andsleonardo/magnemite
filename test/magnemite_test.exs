defmodule MagnemiteTest do
  use Magnemite.DataCase, async: true

  alias Magnemite
  alias Magnemite.{Account, Customers}

  describe "get_or_open_account/1" do
    @valid_account_opening_data %{
      birth_date: Date.to_iso8601(Faker.Date.date_of_birth()),
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      email: Faker.Internet.email(),
      gender: [to_string(Enum.random(Customers.gender_options()))],
      name: Faker.Person.PtBr.name(),
      state: Faker.Address.PtBr.state()
    }

    test """
    returns a %Magnemite.Account{} with pending status and without referral code
    when given a new valid CPF, but not all necessary account opening data
    """ do
      %{cpf: cpf} = @valid_account_opening_data

      assert {:ok,
              %Account{
                status: :pending,
                referral_code: nil
              }} = Magnemite.get_or_open_account(%{cpf: cpf})
    end

    test """
    returns a %Magnemite.Account{} with complete status and referral code
    when given a new valid CPF and all necessary account opening data
    """ do
      assert {:ok,
              %Account{
                status: :complete,
                referral_code: referral_code
              }} = Magnemite.get_or_open_account(@valid_account_opening_data)

      refute is_nil(referral_code)
    end

    test """
    returns a %Magnemite.Account{} with pending status and without referral code
    when given a known valid CPF, but not all necessary account opening data
    """ do
      account_opening_data = Map.take(@valid_account_opening_data, [:cpf, :name, :city])

      assert {:ok,
              %Account{
                status: :pending,
                referral_code: nil
              }} = Magnemite.get_or_open_account(account_opening_data)
    end

    test """
    returns a %Magnemite.Account{} with complete status and referral code
    when given a known valid CPF and all necessary account opening data
    """ do
      assert {:ok,
              %Account{
                status: :complete,
                referral_code: referral_code
              }} = Magnemite.get_or_open_account(@valid_account_opening_data)

      refute is_nil(referral_code)
    end
  end
end
