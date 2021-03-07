defmodule MagnemiteWeb.Api.ParameterizerTest do
  use ExUnit.Case, async: true
  use Magnemite.Changeset

  alias MagnemiteWeb.Api.Parameterizer

  describe "permit_and_require_params/2" do
    @valid_params %{
      field1: "Douglas",
      field2: 42
    }

    def changeset_fun(params) do
      {%{}, %{field1: :string, field2: :integer}}
      |> cast(params, [:field1, :field2])
      |> validate_required([:field1])
    end

    test "maps the changeset changes when the changeset function returns a valid changeset" do
      result = Parameterizer.permit_and_require_params(@valid_params, &changeset_fun/1)

      assert {:ok,
              %{
                field1: "Douglas",
                field2: 42
              }} = result
    end

    test "returns the changeset errors when not all params are valid" do
      invalid_params = Map.drop(@valid_params, [:field1])

      result = Parameterizer.permit_and_require_params(invalid_params, &changeset_fun/1)

      assert {:error, :changeset, %{field1: ["can't be blank"]}} = result
    end
  end
end
