defmodule Magnemite.CustomersTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers
  alias Magnemite.Customers.Customer

  import Magnemite.Factory

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
end
