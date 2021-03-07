defmodule MagnemiteTest do
  use Magnemite.DataCase, async: true

  alias Magnemite
  alias Magnemite.{Account, Customers}

  describe "get_or_open_account/1" do
    @valid_account_opening_data :complete_customer
                                |> params_for()
                                |> Map.merge(params_for(:address))

    test """
    returns a %Magnemite.Account{} with a new customer without referral code
    when given a new valid CPF, but not all necessary account opening data
    """ do
      %{cpf: cpf} = @valid_account_opening_data

      assert {:ok,
              %Account{
                customer: %Customers.Customer{
                  cpf: ^cpf,
                  referral_code: nil
                }
              }} = Magnemite.get_or_open_account(%{cpf: cpf})
    end

    test """
    returns a %Magnemite.Account{} with a new customer with referral code
    when given a new valid CPF and all necessary account opening data
    """ do
      %{cpf: cpf} = @valid_account_opening_data

      assert {:ok,
              %Account{
                customer: %{
                  cpf: ^cpf,
                  referral_code: %{number: referral_code_number}
                }
              }} = Magnemite.get_or_open_account(@valid_account_opening_data)

      refute is_nil(referral_code_number)
    end

    test """
    returns a %Magnemite.Account{} with an updated customer without referral code
    when given a known valid CPF, but not all necessary account opening data
    """ do
      %{cpf: cpf} =
        account_opening_data = Map.take(@valid_account_opening_data, [:cpf, :name, :city])

      %{id: customer_id} = insert(:customer, cpf: cpf)

      assert {:ok,
              %Account{
                customer: %{
                  id: ^customer_id,
                  cpf: ^cpf,
                  referral_code: nil
                }
              }} = Magnemite.get_or_open_account(account_opening_data)
    end

    test """
    returns a %Magnemite.Account{} with an updated customer with referral code
    when given a known valid CPF and all necessary account opening data
    """ do
      %{cpf: cpf} = @valid_account_opening_data

      %{id: customer_id} = insert(:customer, cpf: cpf)

      assert {:ok,
              %Account{
                customer: %{
                  id: ^customer_id,
                  cpf: ^cpf,
                  referral_code: %{number: referral_code_number}
                }
              }} = Magnemite.get_or_open_account(@valid_account_opening_data)

      refute is_nil(referral_code_number)
    end

    test """
    returns a %Magnemite.Account{} with pending status
    when not given all necessary account opening params
    """ do
      assert {:ok,
              %Account{
                status: :pending
              }} = Magnemite.get_or_open_account(%{cpf: @valid_account_opening_data.cpf})
    end

    test """
    returns a %Magnemite.Account{} without :referrer
    when there's no :referral_code in account opening params
    """ do
      account_opening_data = Map.drop(@valid_account_opening_data, [:referral_code])

      assert {:ok, %Account{referrer: nil}} = Magnemite.get_or_open_account(account_opening_data)
    end

    test """
    returns a %Magnemite.Account{} with :referrer
    when there's a :referral_code in account opening params
    """ do
      %{customer_id: referrer_id} = insert(:referral_code, @valid_account_opening_data.referral_code)

      assert {:ok, %Account{referrer: %{id: ^referrer_id}}} =
               Magnemite.get_or_open_account(@valid_account_opening_data)
    end
  end
end
