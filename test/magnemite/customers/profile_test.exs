defmodule Magnemite.Customers.ProfileTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Customers.Profile

  describe "schema/2" do
    test ":birth_date defaults to nil" do
      assert %Profile{birth_date: nil} = %Profile{}
    end

    test ":cpf defaults to nil" do
      assert %Profile{cpf: nil} = %Profile{}
    end

    test ":email defaults to nil" do
      assert %Profile{email: nil} = %Profile{}
    end

    test ":gender defaults to nil" do
      assert %Profile{gender: nil} = %Profile{}
    end

    test ":name defaults to nil" do
      assert %Profile{name: nil} = %Profile{}
    end

    test "has :address association" do
      assert %Profile{address: %Ecto.Association.NotLoaded{}} = %Profile{}
    end

    test "has :account_opening_request association" do
      assert %Profile{account_opening_request: %Ecto.Association.NotLoaded{}} = %Profile{}
    end

    test "has :referral_code association" do
      assert %Profile{referral_code: %Ecto.Association.NotLoaded{}} = %Profile{}
    end

    test "has :user association" do
      assert %Profile{user: %Ecto.Association.NotLoaded{}} = %Profile{}
    end

    test "has timestamps" do
      assert %Profile{inserted_at: _, updated_at: _} = %Profile{}
    end
  end

  describe "creation_changeset/2" do
    @profile_params params_for(:profile, user_id: Ecto.UUID.generate())

    test "casts :birth_date" do
      birth_date = @profile_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               Profile.creation_changeset(%Profile{}, %{birth_date: birth_date})
    end

    test "casts :cpf" do
      cpf = @profile_params.cpf

      assert %Changeset{changes: %{cpf: ^cpf}} =
               Profile.creation_changeset(%Profile{}, %{cpf: cpf})
    end

    test "casts :email" do
      email = @profile_params.email

      assert %Changeset{changes: %{email: ^email}} =
               Profile.creation_changeset(%Profile{}, %{email: email})
    end

    test "casts :name" do
      name = @profile_params.name

      assert %Changeset{changes: %{name: ^name}} =
               Profile.creation_changeset(%Profile{}, %{name: name})
    end

    test "casts :gender" do
      gender = @profile_params.gender

      assert %Changeset{changes: %{gender: ^gender}} =
               Profile.creation_changeset(%Profile{}, %{gender: gender})
    end

    test "casts :user_id" do
      user_id = @profile_params.user_id

      assert %Changeset{changes: %{user_id: ^user_id}} =
        Profile.creation_changeset(%Profile{}, %{user_id: user_id})
    end

    test "casts :address association" do
      address_params = params_for(:address)

      assert %Changeset{changes: %{address: %Changeset{}}} =
               Profile.creation_changeset(%Profile{}, %{address: address_params})
    end

    test "requires :gender to be within range of gender options" do
      errors =
        %Profile{}
        |> Profile.creation_changeset(%{gender: ["invalid_gender_option"]})
        |> errors_on(:gender)

      assert "is invalid" in errors
    end

    test "doesn't accept an invalid :email" do
      errors =
        %Profile{}
        |> Profile.creation_changeset(%{email: "invalid_email"})
        |> errors_on(:email)

      assert "is an invalid email" in errors
    end

    test "doesn't accept an invalid :cpf" do
      errors =
        %Profile{}
        |> Profile.creation_changeset(%{cpf: "12345678911"})
        |> errors_on(:cpf)

      assert "is an invalid CPF" in errors
    end
  end

  describe "update_changeset/2" do
    @profile_params params_for(:profile)

    test "casts :birth_date" do
      birth_date = @profile_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               Profile.update_changeset(%Profile{}, %{birth_date: birth_date})
    end

    test "casts :email" do
      email = @profile_params.email

      assert %Changeset{changes: %{email: ^email}} =
               Profile.update_changeset(%Profile{}, %{email: email})
    end

    test "casts :name" do
      name = @profile_params.name

      assert %Changeset{changes: %{name: ^name}} =
               Profile.update_changeset(%Profile{}, %{name: name})
    end

    test "casts :gender" do
      gender = @profile_params.gender

      assert %Changeset{changes: %{gender: ^gender}} =
               Profile.update_changeset(%Profile{}, %{gender: gender})
    end

    test "casts :address association" do
      address_params = params_for(:address)

      assert %Changeset{changes: %{address: %Changeset{}}} =
               Profile.update_changeset(%Profile{}, %{address: address_params})
    end

    test "doesn't cast :cpf" do
      cpf = @profile_params.cpf

      assert %Changeset{changes: changes} = Profile.update_changeset(%Profile{}, %{cpf: cpf})

      refute :cpf in Map.keys(changes)
    end

    test "requires :gender to be within range of gender options" do
      errors =
        %Profile{}
        |> Profile.update_changeset(%{gender: ["invalid_gender_option"]})
        |> errors_on(:gender)

      assert "is invalid" in errors
    end

    test "doesn't accept an invalid :email" do
      errors =
        %Profile{}
        |> Profile.creation_changeset(%{email: "invalid_email"})
        |> errors_on(:email)

      assert "is an invalid email" in errors
    end

    test "doesn't accept an invalid :cpf" do
      errors =
        %Profile{}
        |> Profile.creation_changeset(%{cpf: "12345678911"})
        |> errors_on(:cpf)

      assert "is an invalid CPF" in errors
    end
  end
end
