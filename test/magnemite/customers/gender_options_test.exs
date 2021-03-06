defmodule Magnemite.Customers.GenderOptionsTest do
  use ExUnit.Case, async: true

  alias Magnemite.Customers.GenderOptions

  describe "list/0" do
    test "returns a list of gender options" do
      assert GenderOptions.list() == [
               :female,
               :male,
               :non_binary,
               :other,
               :rather_not_say,
               :transgender
             ]
    end
  end
end
