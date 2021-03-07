defmodule Magnemite.Factories.CustomerFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def customer_factory do
        %Customers.Customer{
          birth_date: Faker.Date.date_of_birth(),
          cpf: random_cpf(),
          email: Faker.Internet.email(),
          gender: [random_gender()],
          name: Faker.Person.PtBr.name()
        }
      end

      def complete_customer_factory(attrs) do
        customer_factory()
        |> merge_attributes(referral_code: build(:referral_code))
        |> merge_attributes(attrs)
      end

      def incomplete_customer_factory do
        %Customers.Customer{
          cpf: random_cpf()
        }
      end

      defp random_cpf do
        Brcpfcnpj.cpf_generate()
      end

      defp random_gender do
        Enum.random(Customers.GenderOptions.list())
      end
    end
  end
end
