defmodule MagnemiteTest do
  use Magnemite.DataCase, async: true

  alias Magnemite
  alias Magnemite.Customers.GenderOptions

  describe "list_referred_accounts/1" do
    test "" do
      referrer = insert(:profile)
      insert(:complete_account_opening_request, profile: referrer)

      %{id: complete_account_opening_request1} =
        insert(:complete_account_opening_request, referrer: referrer)

      %{id: complete_account_opening_request2} =
        insert(:complete_account_opening_request, referrer: referrer)

      %{id: pending_account_opening_request} =
        insert(:pending_account_opening_request, referrer: referrer)

      assert {:ok, [_, _] = referred_accounts} = Magnemite.list_referred_accounts(referrer.user_id)

      referred_accounts_ids = Enum.map(referred_accounts, & &1.id)

      assert complete_account_opening_request1 in referred_accounts_ids
      assert complete_account_opening_request2 in referred_accounts_ids
      refute pending_account_opening_request in referred_accounts_ids
    end
  end

  describe "get_or_open_account/1" do
    @account_opening_data %{
      birth_date: Date.to_iso8601(Faker.Date.date_of_birth()),
      cpf: Brcpfcnpj.cpf_generate(),
      city: Faker.Address.PtBr.city(),
      country: Faker.Address.PtBr.country(),
      email: Faker.Internet.email(),
      gender: [to_string(Enum.random(GenderOptions.list()))],
      name: Faker.Person.PtBr.name(),
      state: Faker.Address.PtBr.state()
    }

    setup do
      user = insert(:user)

      %{
        user: user
      }
    end

    test """
         returns an account with pending status and without referral code
         when given a new valid CPF, but not all necessary account opening data
         """,
         %{
           user: user
         } do
      valid_account_opening_data = Map.take(@account_opening_data, [:cpf])

      result = Magnemite.get_or_open_account(user.id, valid_account_opening_data)

      assert {:ok,
              %{
                status: :pending,
                referral_code: nil
              }} = result
    end

    test """
         returns an account with complete status and referral code
         when given a new valid CPF and all necessary account opening data
         """,
         %{
           user: user
         } do
      result = Magnemite.get_or_open_account(user.id, @account_opening_data)

      assert {:ok,
              %{
                status: :done,
                referral_code: referral_code
              }} = result

      refute is_nil(referral_code)
    end

    test """
         returns an account with pending status and without referral code
         when given a known valid CPF, but not all necessary account opening data
         """,
         %{
           user: user
         } do
      insert(:profile, cpf: @account_opening_data.cpf, user: user)

      valid_account_opening_data = Map.take(@account_opening_data, [:city, :cpf, :email, :name])

      result = Magnemite.get_or_open_account(user.id, valid_account_opening_data)

      assert {:ok,
              %{
                status: :pending,
                referral_code: nil
              }} = result
    end

    test """
         returns an account with complete status and referral code
         when given a known valid CPF and all necessary account opening data
         """,
         %{
           user: user
         } do
      insert(:profile, cpf: @account_opening_data.cpf, user: user)

      result = Magnemite.get_or_open_account(user.id, @account_opening_data)

      assert {:ok,
              %{
                status: :done,
                referral_code: referral_code
              }} = result

      refute is_nil(referral_code)
    end
  end
end
