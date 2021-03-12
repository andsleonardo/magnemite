defmodule Magnemite.Factories.ReferralCodeFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def referral_code_factory do
        %Customers.ReferralCode{
          number: referral_code_number(),
          profile: build(:profile)
        }
      end
    end
  end
end
