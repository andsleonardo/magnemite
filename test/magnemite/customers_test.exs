defmodule Magnemite.CustomersTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers
  alias Magnemite.Customers.{Customer, ReferralCode}

  describe "list_customers/0" do
    test "returns the customers in the database when there are any" do
      %{id: customer1_id} = insert(:customer)
      %{id: customer2_id} = insert(:customer)

      assert [%{id: ^customer1_id}, %{id: ^customer2_id}] = Customers.list_customers()
    end

    test "returns an empty list when there aren't customers in the database" do
      assert [] = Customers.list_customers()
    end
  end

  describe "get_customer/1" do
    test "returns a customer when it exists" do
      %{id: customer_id} = insert(:customer)

      assert {:ok, %Customer{id: ^customer_id}} = Customers.get_customer(customer_id)
    end

    test "returns an error when no customer matches the given id" do
      assert {:error, :customer_not_found} = Customers.get_customer(Ecto.UUID.generate())
    end
  end

  describe "get_customer_by/1" do
    setup do
      %{
        customer: insert(:customer)
      }
    end

    test "returns a customer when such record meets the given criteria", %{
      customer: %{id: customer_id} = customer
    } do
      assert {:ok, %Customer{id: ^customer_id}} =
               Customers.get_customer_by(user_id: customer.user_id)
    end

    test "returns an error when no customer meets the given criteria" do
      assert {:error, :customer_not_found} =
               Customers.get_customer_by(user_id: Ecto.UUID.generate())
    end
  end

  describe "get_referrer/1" do
    setup do
      %{
        customer: insert(:customer)
      }
    end

    test "returns the customer having the given referral code number", %{
      customer: %{id: customer_id} = customer
    } do
      referral_code = insert(:referral_code, customer: customer)

      assert {:ok, %Customer{id: ^customer_id}} = Customers.get_referrer(referral_code.number)
    end

    test "returns an error when there is no customer with the given referral code" do
      referral_code_number = Customers.generate_referral_code_number()

      assert {:error, :invalid_referral_code} = Customers.get_referrer(referral_code_number)
    end
  end

  describe "upsert_customer_by_cpf/2" do
    setup do
      %{
        customer_params: params_for(:customer)
      }
    end

    test "creates a new customer with CPF and params when no record exists", %{
      customer_params:
        %{
          birth_date: new_birth_date,
          cpf: new_cpf,
          email: new_email,
          gender: new_gender,
          name: new_name
        } = new_customer_params
    } do
      assert [] = Customers.list_customers()

      user = insert(:user)

      new_customer_params = Map.merge(new_customer_params, %{user_id: user.id})
      result = Customers.upsert_customer_by_cpf(new_cpf, new_customer_params)

      {:ok,
       %Customer{
         birth_date: ^new_birth_date,
         cpf: ^new_cpf,
         email: ^new_email,
         gender: ^new_gender,
         name: ^new_name
       }} = result

      assert [_] = Customers.list_customers()
    end

    test "updates the customer matching CPF with params when a record exist", %{
      customer_params:
        %{
          birth_date: new_birth_date,
          email: new_email,
          gender: new_gender,
          name: new_name
        } = new_customer_params
    } do
      %{cpf: expected_cpf} = existing_customer = insert(:customer)

      assert [_] = Customers.list_customers()

      result = Customers.upsert_customer_by_cpf(existing_customer.cpf, new_customer_params)

      {:ok,
       %Customer{
         birth_date: ^new_birth_date,
         cpf: ^expected_cpf,
         email: ^new_email,
         gender: ^new_gender,
         name: ^new_name
       }} = result

      assert [_] = Customers.list_customers()
    end
  end

  describe "complete_customer_with_address?/1" do
    @complete_customer build(:customer, address: build(:address))

    test "returns false when customer is incomplete" do
      customer = %{@complete_customer | name: nil}

      refute Customers.complete_customer_with_address?(customer)
    end

    test "returns false when customer is complete, but their address is not" do
      customer = %{@complete_customer | address: build(:address, city: nil)}

      refute Customers.complete_customer_with_address?(customer)
    end

    test "returns true when customer and their address are complete" do
      assert Customers.complete_customer_with_address?(@complete_customer)
    end
  end

  describe "list_referral_codes_numbers/0" do
    test "lists the referral codes numbers in the database" do
      [
        %{number: number1},
        %{number: number2},
        %{number: number3}
      ] = insert_list(3, :referral_code)

      referral_codes_numbers = Customers.list_referral_codes_numbers()

      assert number1 in referral_codes_numbers
      assert number2 in referral_codes_numbers
      assert number3 in referral_codes_numbers
    end
  end

  describe "get_or_create_referral_code/1" do
    setup do
      %{
        customer: insert(:customer)
      }
    end

    test "returns a referral code if one already exists for the given customer", %{
      customer: customer
    } do
      %{id: referral_code_id} = insert(:referral_code, customer: customer)

      assert [_] = Customers.list_referral_codes_numbers()

      assert {:ok, %ReferralCode{id: ^referral_code_id}} =
               Customers.get_or_create_referral_code(customer)

      assert [_] = Customers.list_referral_codes_numbers()
    end

    test "creates a referral code when none was created for the given customer before", %{
      customer: customer
    } do
      assert [] = Customers.list_referral_codes_numbers()

      assert {:ok, %ReferralCode{number: referral_code_number}} =
               Customers.get_or_create_referral_code(customer)

      assert [^referral_code_number] = Customers.list_referral_codes_numbers()
    end
  end
end
