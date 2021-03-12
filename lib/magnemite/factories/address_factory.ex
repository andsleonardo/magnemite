defmodule Magnemite.Factories.AddressFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def address_factory do
        %Customers.Address{
          city: Faker.Address.PtBr.city(),
          country: Faker.Address.PtBr.country(),
          state: Faker.Address.PtBr.state(),
          profile: build(:profile)
        }
      end
    end
  end
end
