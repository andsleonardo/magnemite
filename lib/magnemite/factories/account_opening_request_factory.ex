defmodule Magnemite.Factories.AccountOpeningRequestFactory do
  @moduledoc false

  alias Magnemite.Accounts

  defmacro __using__(_opts) do
    quote do
      def pending_account_opening_request_factory do
        account_opening_request_factory(status: :pending)
      end

      def complete_account_opening_request_factory do
        account_opening_request_factory(status: :complete)
      end

      def account_opening_request_factory(attrs) do
        %Accounts.AccountOpeningRequest{
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
