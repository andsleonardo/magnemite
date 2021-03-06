defmodule Magnemite.Accounts.AccountOpeningRequestTest do
  use ExUnit.Case, async: true
  use Magnemite.Changeset

  alias Magnemite.Accounts.AccountOpeningRequest

  describe "schema/2" do
    test ":status defaults to :pending" do
      assert %AccountOpeningRequest{status: :pending} = %AccountOpeningRequest{}
    end

    test "has :customer association" do
      assert %AccountOpeningRequest{customer: %Ecto.Association.NotLoaded{}} =
               %AccountOpeningRequest{}
    end
  end

  describe "changeset/2" do
    test "casts :status" do
      status = :complete

      assert %Changeset{changes: %{status: ^status}} =
               AccountOpeningRequest.changeset(%AccountOpeningRequest{}, %{status: status})
    end

    test "requires :status to be within range of status options" do
      errors =
        %AccountOpeningRequest{}
        |> AccountOpeningRequest.changeset(%{status: ["invalid_status_option"]})
        |> errors_on(:status)

      assert "is invalid" in errors
    end
  end
end
