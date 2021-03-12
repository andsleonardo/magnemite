defmodule Magnemite.Customers.ReferralCodeTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Customers.ReferralCode

  import Magnemite.Factory

  describe "schema/2" do
    test ":number defaults to nil" do
      assert %ReferralCode{number: nil} = %ReferralCode{}
    end

    test "has :profile association" do
      assert %ReferralCode{profile: %Ecto.Association.NotLoaded{}} = %ReferralCode{}
    end

    test "has timestamps" do
      assert %ReferralCode{inserted_at: _, updated_at: _} = %ReferralCode{}
    end
  end

  describe "changeset/2" do
    @referral_code_params params_for(:referral_code)

    test "casts :number" do
      number = @referral_code_params.number

      assert %Changeset{changes: %{number: ^number}} =
               ReferralCode.changeset(%ReferralCode{}, %{number: number})
    end

    test "casts :profile_id" do
      %{id: profile_id} = insert(:profile)

      assert %Changeset{changes: %{profile_id: ^profile_id}} =
               ReferralCode.changeset(%ReferralCode{}, %{profile_id: profile_id})
    end

    test "requires :number" do
      errors =
        %ReferralCode{}
        |> ReferralCode.changeset(%{number: nil})
        |> errors_on(:number)

      assert "can't be blank" in errors
    end

    test "invalidates :number without 8-digit format" do
      number = "1234567"

      errors =
        %ReferralCode{}
        |> ReferralCode.changeset(%{number: number})
        |> errors_on(:number)

      assert "has invalid format" in errors
    end

    test "invalidates a non-unique :number" do
      referral_code = insert(:referral_code)

      errors =
        %ReferralCode{}
        |> ReferralCode.changeset(%{number: referral_code.number})
        |> errors_on(:number)

      assert "has already been taken" in errors
    end

    test "invalidates a non-unique :profile_id" do
      referral_code = insert(:referral_code)

      errors =
        %ReferralCode{}
        |> ReferralCode.changeset(%{profile_id: referral_code.profile_id})
        |> errors_on(:profile_id)

      assert "has already been taken" in errors
    end
  end
end
