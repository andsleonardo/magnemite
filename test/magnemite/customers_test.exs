defmodule Magnemite.CustomersTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers
  alias Magnemite.Customers.Profile

  describe "get_referrer/1" do
    setup do
      %{
        profile: insert(:profile)
      }
    end

    test "returns the profile having the given referral code number", %{
      profile: %{id: profile_id} = profile
    } do
      referral_code = insert(:referral_code, profile: profile)

      assert {:ok, %Profile{id: ^profile_id}} = Customers.get_referrer(referral_code.number)
    end

    test "returns an error when there is no profile with the given referral code" do
      assert {:error, :invalid_referral_code} = Customers.get_referrer("12345678")
    end
  end

  describe "upsert_profile/2" do
    setup do
      %{
        profile_params: params_for(:profile),
        user: insert(:user)
      }
    end

    test "creates a new profile with CPF and params when no record exists", %{
      profile_params:
        %{
          birth_date: new_birth_date,
          email: new_email,
          gender: new_gender,
          name: new_name
        } = new_profile_params,
      user: user
    } do
      {:ok,
       %Profile{
         birth_date: ^new_birth_date,
         email: ^new_email,
         gender: ^new_gender,
         name: ^new_name
       }} = Customers.upsert_profile(user.id, new_profile_params)
    end

    test "updates the profile matching CPF with params when a record exist", %{
      profile_params:
        %{
          birth_date: new_birth_date,
          email: new_email,
          gender: new_gender,
          name: new_name
        } = new_profile_params,
      user: user
    } do
      existing_profile = insert(:profile, user: user)

      {:ok,
       %Profile{
         birth_date: ^new_birth_date,
         email: ^new_email,
         gender: ^new_gender,
         name: ^new_name
       }} = Customers.upsert_profile(existing_profile.user_id, new_profile_params)
    end
  end
end
