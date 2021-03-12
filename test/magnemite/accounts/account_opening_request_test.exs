defmodule Magnemite.Accounts.AccountOpeningRequestTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Accounts.AccountOpeningRequest

  import Magnemite.Factory

  describe "schema/2" do
    test "has :status and it defaults to :pending" do
      assert %AccountOpeningRequest{status: :pending} = %AccountOpeningRequest{}
    end

    test "has :profile association through :profile_id" do
      assert %AccountOpeningRequest{profile: %Ecto.Association.NotLoaded{}, profile_id: nil} =
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

    test "casts :profile_id as string" do
      profile_id = Ecto.UUID.generate()

      assert %Changeset{changes: %{profile_id: ^profile_id}} =
               AccountOpeningRequest.changeset(%AccountOpeningRequest{}, %{
                 profile_id: profile_id
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

    test "invalidates a non-unique :profile_id" do
      %{profile_id: profile_id} = insert(:account_opening_request)

      errors =
        %AccountOpeningRequest{}
        |> AccountOpeningRequest.changeset(%{profile_id: profile_id})
        |> errors_on(:profile_id)

      assert "has already been taken" in errors
    end
  end
end
