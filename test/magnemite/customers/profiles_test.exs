defmodule Magnemite.Customers.ProfilesTest do
  use Magnemite.DataCase, async: true

  alias Magnemite.Customers.{Profile, Profiles}

  describe "get/1" do
    test "gets the profile matching id" do
      %{id: profile_id} = insert(:profile)

      assert {:ok, %Profile{id: ^profile_id}} = Profiles.get(profile_id)
    end

    test "returns an error when no profile matches id" do
      assert {:error, :profile_not_found} = Profiles.get(Ecto.UUID.generate())
    end
  end

  describe "get_by_user_id/1" do
    test "gets the profile matching user_id" do
      %{id: profile_id} = profile = insert(:profile)

      assert {:ok, %Profile{id: ^profile_id}} = Profiles.get_by_user_id(profile.user_id)
    end

    test "returns an error when no profile meets criteria" do
      assert {:error, :profile_not_found} = Profiles.get_by_user_id(Ecto.UUID.generate())
    end
  end

  describe "get_by_referral_code/1" do
    test "gets the profile matching referral_code" do
      %{profile: %{id: profile_id}} = referral_code = insert(:referral_code)

      assert {:ok, %Profile{id: ^profile_id}} =
               Profiles.get_by_referral_code(referral_code.number)
    end

    test "returns an error when no profile matches referral_code" do
      assert {:error, :profile_not_found} = Profiles.get_by_referral_code("12345678")
    end
  end

  describe "upsert_by_user_id/2" do
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
       }} = Profiles.upsert_by_user_id(user.id, new_profile_params)
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
       }} = Profiles.upsert_by_user_id(existing_profile.user_id, new_profile_params)
    end
  end

  describe "create/1" do
    test "creates a profile when all valid and required params are given" do
      %{id: user_id} = user = insert(:user)
      profile_params = params_for(:profile, user_id: user.id)

      assert {:ok, %Profile{user_id: ^user_id}} = Profiles.create(profile_params)
    end

    test "returns an error when any of the required params are not given or valid" do
      assert {:error, :changeset, _} = Profiles.create(%{})
    end
  end

  describe "update/2" do
    setup do
      user = insert(:user)
      profile_params = params_for(:profile, user_id: user.id)
      {:ok, profile} = Profiles.create(profile_params)

      %{
        profile: profile
      }
    end

    test "updates a profile when all valid and required params are given", %{
      profile: %{id: profile_id} = profile
    } do
      new_email = Faker.Internet.email()

      assert {:ok, %Profile{id: ^profile_id, email: ^new_email}} =
               Profiles.update(profile, %{email: new_email})
    end

    test "returns an error when any of the required params are not given or valid", %{
      profile: profile
    } do
      assert {:error, :changeset, _} = Profiles.update(profile, %{email: "invalid_email"})
    end
  end
end
