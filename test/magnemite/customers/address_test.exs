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

    test ":customer_id defaults to nil" do
      assert %Address{customer_id: nil} = %Address{}
    end

    test ":state defaults to nil" do
      assert %Address{state: nil} = %Address{}
    end

    test "has :customer association" do
      assert %Address{customer: %Ecto.Association.NotLoaded{}} = %Address{}
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
