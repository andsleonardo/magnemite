defmodule Magnemite.Customers.CustomerTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Customers.Customer

  import Magnemite.Factory

  describe "schema/2" do
    test ":birth_date defaults to nil" do
      assert %Customer{birth_date: nil} = %Customer{}
    end

    test ":cpf defaults to nil" do
      assert %Customer{cpf: nil} = %Customer{}
    end

    test ":email defaults to nil" do
      assert %Customer{email: nil} = %Customer{}
    end

    test ":gender defaults to nil" do
      assert %Customer{gender: nil} = %Customer{}
    end

    test ":name defaults to nil" do
      assert %Customer{name: nil} = %Customer{}
    end

    test "has :address association" do
      assert %Customer{address: %Ecto.Association.NotLoaded{}} = %Customer{}
    end
  end

  describe "creation_changeset/2" do
    @customer_params params_for(:customer)

    test "casts :birth_date" do
      birth_date = @customer_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               Customer.creation_changeset(%Customer{}, %{birth_date: birth_date})
    end

    test "casts :cpf" do
      cpf = @customer_params.cpf

      assert %Changeset{changes: %{cpf: ^cpf}} =
               Customer.creation_changeset(%Customer{}, %{cpf: cpf})
    end

    test "casts :email" do
      email = @customer_params.email

      assert %Changeset{changes: %{email: ^email}} =
               Customer.creation_changeset(%Customer{}, %{email: email})
    end

    test "casts :name" do
      name = @customer_params.name

      assert %Changeset{changes: %{name: ^name}} =
               Customer.creation_changeset(%Customer{}, %{name: name})
    end

    test "casts :gender" do
      gender = @customer_params.gender

      assert %Changeset{changes: %{gender: ^gender}} =
               Customer.creation_changeset(%Customer{}, %{gender: gender})
    end

    test "requires :gender to be within range of gender options" do
      errors =
        %Customer{}
        |> Customer.creation_changeset(%{gender: ["invalid_gender_option"]})
        |> errors_on(:gender)

      assert "is invalid" in errors
    end

    test "invalidates a non-unique :cpf" do
      existing_customer = insert(:customer)

      errors =
        %Customer{}
        |> Customer.creation_changeset(%{cpf: existing_customer.cpf})
        |> errors_on(:cpf)

      assert "has already been taken" in errors
    end
  end

  describe "update_changeset/2" do
    @customer_params params_for(:customer)

    test "casts :birth_date" do
      birth_date = @customer_params.birth_date

      assert %Changeset{changes: %{birth_date: ^birth_date}} =
               Customer.update_changeset(%Customer{}, %{birth_date: birth_date})
    end

    test "casts :email" do
      email = @customer_params.email

      assert %Changeset{changes: %{email: ^email}} =
               Customer.update_changeset(%Customer{}, %{email: email})
    end

    test "casts :name" do
      name = @customer_params.name

      assert %Changeset{changes: %{name: ^name}} =
               Customer.update_changeset(%Customer{}, %{name: name})
    end

    test "casts :gender" do
      gender = @customer_params.gender

      assert %Changeset{changes: %{gender: ^gender}} =
               Customer.update_changeset(%Customer{}, %{gender: gender})
    end

    test "doesn't cast :cpf" do
      cpf = @customer_params.cpf

      assert %Changeset{changes: changes} = Customer.update_changeset(%Customer{}, %{cpf: cpf})

      refute :cpf in Map.keys(changes)
    end

    test "requires :gender to be within range of gender options" do
      errors =
        %Customer{}
        |> Customer.update_changeset(%{gender: ["invalid_gender_option"]})
        |> errors_on(:gender)

      assert "is invalid" in errors
    end
  end
end
