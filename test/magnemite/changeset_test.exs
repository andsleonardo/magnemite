defmodule Magnemite.ChangesetTest do
  use ExUnit.Case, async: true

  alias Magnemite.Changeset

  @changeset %Ecto.Changeset{
    types: [{:field1, :integer}, {:field2, :string}],
    errors: [
      field1: {"can't be blank", []},
      field2: {"is invalid", []}
    ]
  }

  describe "errors_on/1" do
    test "transforms changeset errors to a map of messages" do
      assert %{
               field1: ["can't be blank"],
               field2: ["is invalid"]
             } = Changeset.errors_on(@changeset)
    end

    test "returns an empty map when there aren't errors in a changeset" do
      assert %{} = Changeset.errors_on(%{@changeset | errors: []})
    end
  end

  describe "errors_on/2" do
    test "lists changeset errors under a field when there are any" do
      assert ["can't be blank"] = Changeset.errors_on(@changeset, :field1)
    end

    test "returns an empty list when there aren't changeset errors under a field" do
      assert [] = Changeset.errors_on(@changeset, :field3)
    end
  end
end
