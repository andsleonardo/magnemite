defmodule Magnemite.Customers.AddressTest do
  use Magnemite.DataCase, async: true
  use Magnemite.Changeset

  alias Magnemite.Customers.Address

  import Magnemite.Factory

  describe "schema/2" do
    test ":city defaults to nil" do
      assert %Address{city: nil} = %Address{}
    end

    test ":country defaults to nil" do
      assert %Address{country: nil} = %Address{}
    end

    test ":profile_id defaults to nil" do
      assert %Address{profile_id: nil} = %Address{}
    end

    test ":state defaults to nil" do
      assert %Address{state: nil} = %Address{}
    end

    test "has :profile association" do
      assert %Address{profile: %Ecto.Association.NotLoaded{}} = %Address{}
    end

    test "has timestamps" do
      assert %Address{inserted_at: _, updated_at: _} = %Address{}
    end
  end

  describe "changeset/2" do
    @address_params params_for(:address)

    test "casts :city" do
      city = @address_params.city

      assert %Changeset{changes: %{city: ^city}} = Address.changeset(%Address{}, %{city: city})
    end

    test "casts :state" do
      state = @address_params.state

      assert %Changeset{changes: %{state: ^state}} =
               Address.changeset(%Address{}, %{state: state})
    end

    test "casts :country" do
      country = @address_params.country

      assert %Changeset{changes: %{country: ^country}} =
               Address.changeset(%Address{}, %{country: country})
    end
  end
end
