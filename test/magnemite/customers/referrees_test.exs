defmodule Magnemite.Customers.ReferreesTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.{Referree, Referrees}

  describe "build/2" do
    test "builds a referree with account_id and name" do
      account_id = Ecto.UUID.generate()
      name = Faker.Person.PtBr.name()

      assert %Referree{account_id: ^account_id, name: ^name} = Referrees.build(account_id, name)
    end
  end
end
