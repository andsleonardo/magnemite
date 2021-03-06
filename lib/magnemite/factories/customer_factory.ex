defmodule Magnemite.Factories.CustomerFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def customer_factory do
        %Customers.Customer{
          birth_date: Faker.Date.date_of_birth(),
          cpf: Brcpfcnpj.cpf_generate(),
          email: Faker.Internet.email(),
          gender: [random_gender()],
          name: Faker.Person.PtBr.name(),
        }
      end

      def with_address(%Customers.Customer{} = customer) do
        insert(:address, customer: customer)
        customer
      end

      defp random_gender do
        Enum.random(Customers.GenderOptions.list())
      end
    end
  end
end
