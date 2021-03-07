defmodule Magnemite.Accounts.AccountOpeningRequestTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Accounts.AccountOpeningRequest

  import Magnemite.Factory

  describe "schema/2" do
    test ":status defaults to :pending" do
      assert %AccountOpeningRequest{status: :pending} = %AccountOpeningRequest{}
    end

    test "has :customer association" do
      assert %AccountOpeningRequest{customer: %Ecto.Association.NotLoaded{}} =
               %AccountOpeningRequest{}
    end

    test "has timestamps" do
      assert %AccountOpeningRequest{inserted_at: _, updated_at: _} = %AccountOpeningRequest{}
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

    test "invalidates a non-unique :customer_id" do
      %{customer_id: customer_id} = insert(:account_opening_request)

      errors =
        %AccountOpeningRequest{}
        |> AccountOpeningRequest.changeset(%{customer_id: customer_id})
        |> errors_on(:customer_id)

      assert "has already been taken" in errors
    end
  end
end
