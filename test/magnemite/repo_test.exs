defmodule Magnemite.RepoTest do
  use ExUnit.Case, async: true

  alias Magnemite.Repo

  describe "handle_operation_result/1" do
    test "returns the successful output when given an :ok tuple" do
      output = {:ok, %{field: "value"}}

      assert ^output = Repo.handle_operation_result(output)
    end

    test "returns transformed changeset errors when given an :error tuple with a changeset" do
      changeset = %Ecto.Changeset{
        types: [{:field1, :integer}, {:field2, :string}],
        errors: [
          field1: {"can't be blank", []},
          field2: {"is invalid", []}
        ]
      }

      assert {:error, :changeset,
              %{
                field1: ["can't be blank"],
                field2: ["is invalid"]
              }} = Repo.handle_operation_result({:error, changeset})
    end
  end
end
