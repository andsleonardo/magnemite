defmodule Magnemite.Accounts.AccountOpeningRequestTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Accounts.AccountOpeningRequest

  import Magnemite.Factory

  describe "schema/2" do
    test "has :status and it defaults to :pending" do
      assert %AccountOpeningRequest{status: :pending} = %AccountOpeningRequest{}
    end

    test "has :customer association through :customer_id" do
      assert %AccountOpeningRequest{customer: %Ecto.Association.NotLoaded{}, customer_id: nil} =
               %AccountOpeningRequest{}
    end

    test "has :referrer association" do
      assert %AccountOpeningRequest{referrer: %Ecto.Association.NotLoaded{}, referrer_id: nil} =
               %AccountOpeningRequest{}
    end

    test "has timestamps" do
      assert %AccountOpeningRequest{inserted_at: _, updated_at: _} = %AccountOpeningRequest{}
    end
  end

  describe "changeset/2" do
    test "casts :status as atom" do
      status = :complete

      assert %Changeset{changes: %{status: ^status}} =
               AccountOpeningRequest.changeset(%AccountOpeningRequest{}, %{status: status})
    end

    test "casts :customer_id as string" do
      customer_id = Ecto.UUID.generate()

      assert %Changeset{changes: %{customer_id: ^customer_id}} =
               AccountOpeningRequest.changeset(%AccountOpeningRequest{}, %{
                 customer_id: customer_id
               })
    end

    test "casts :referrer_id as string" do
      referrer_id = Ecto.UUID.generate()

      assert %Changeset{changes: %{referrer_id: ^referrer_id}} =
               AccountOpeningRequest.changeset(%AccountOpeningRequest{}, %{
                 referrer_id: referrer_id
               })
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
