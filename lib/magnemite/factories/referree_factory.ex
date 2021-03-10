defmodule Magnemite.Factories.ReferreeFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def referree_factory do
        %Customers.Referree{
          account_id: Ecto.UUID.generate(),
          name: Faker.Person.name()
        }
      end
    end
  end
end
