defmodule Magnemite.Factories.ProfileFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def profile_factory do
        cpf = random_cpf()

        %Customers.Profile{
          birth_date: Faker.Date.date_of_birth(),
          cpf: cpf,
          cpf_hash: cpf_hash(cpf),
          email: Faker.Internet.email(),
          gender: [random_gender()],
          name: Faker.Person.PtBr.name(),
          user: build(:user)
        }
      end

      def complete_profile_factory(attrs) do
        profile_factory()
        |> merge_attributes(referral_code: build(:referral_code))
        |> merge_attributes(attrs)
      end

      def incomplete_profile_factory do
        %Customers.Profile{
          cpf: random_cpf()
        }
      end

      defp random_cpf do
        Brcpfcnpj.cpf_generate()
      end

      defp random_gender do
        Enum.random(Customers.GenderOptions.list())
      end

      defp cpf_hash(cpf) do
        :sha256
        |> :crypto.hash(cpf)
        |> Base.encode64()
      end
    end
  end
end
