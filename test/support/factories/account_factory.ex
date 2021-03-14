defmodule Magnemite.Factories.AccountFactory do
  @moduledoc false

  alias Magnemite.Accounts

  defmacro __using__(_opts) do
    quote do
      def pending_account_factory do
        account_factory(status: :pending)
      end

      def complete_account_factory do
        account_factory(status: :complete)
      end

      def account_factory(attrs) do
        %Accounts.Account{
          id: Ecto.UUID.generate(),
          name: Faker.Person.PtBr.name(),
          referral_code: referral_code_number(),
          status: random_status()
        }
        |> merge_attributes(attrs)
      end

      defp random_status do
        Enum.random(Accounts.AccountOpeningRequestStatuses.list())
      end
    end
  end
end
