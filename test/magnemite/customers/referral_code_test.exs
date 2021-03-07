defmodule Magnemite.Customers.ReferralCodeTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Customers.ReferralCode

  import Magnemite.Factory

  describe "schema/2" do
    test ":number defaults to nil" do
      assert %ReferralCode{number: nil} = %ReferralCode{}
    end

    test "has :customer association" do
      assert %ReferralCode{customer: %Ecto.Association.NotLoaded{}} = %ReferralCode{}
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

    test "casts :customer_id" do
      %{id: customer_id} = insert(:customer)

      assert %Changeset{changes: %{customer_id: ^customer_id}} =
               ReferralCode.changeset(%ReferralCode{}, %{customer_id: customer_id})
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

    test "invalidates a non-unique :customer_id" do
      referral_code = insert(:referral_code)

      errors =
        %ReferralCode{}
        |> ReferralCode.changeset(%{customer_id: referral_code.customer_id})
        |> errors_on(:customer_id)

      assert "has already been taken" in errors
    end
  end
end
