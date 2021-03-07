defmodule Magnemite.Factories.AccountFactory do
  @moduledoc false

  alias Magnemite.{Account, Accounts}

  defmacro __using__(_opts) do
    quote do
      def pending_account_factory do
        account_factory(status: :pending)
      end

      def complete_account_factory do
        account_factory(status: :complete)
      end

      def account_factory(attrs) do
        %Account{
          customer: build(:customer),
          referrer: build(:customer),
          status: random_status()
        }
        |> merge_attributes(attrs)
      end

      defp random_status do
        Enum.random(Accounts.account_opening_request_statuses())
      end
    end
  end
end
