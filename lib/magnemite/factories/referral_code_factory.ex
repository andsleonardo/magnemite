defmodule Magnemite.Factories.ReferralCodeFactory do
  @moduledoc false

  alias Magnemite.Customers

  defmacro __using__(_opts) do
    quote do
      def referral_code_factory do
        %Customers.ReferralCode{
          number: number(),
          customer: build(:customer)
        }
      end

      defp number do
        Nanoid.generate_non_secure(8, "123456789")
      end
    end
  end
end
