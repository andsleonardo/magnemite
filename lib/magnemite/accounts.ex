defmodule Magnemite.Accounts do
  @moduledoc """
  Internal API for Accounts.
  """

  alias __MODULE__.{
    Account,
    AccountOpeningRequest,
    AccountOpeningRequests,
    AccountOpeningRequestQuery,
    AccountOpeningRequestStatuses
  }

  alias Magnemite.Repo

  @doc """
  Lists the possible account opening request statuses.
  """
  @spec account_opening_request_statuses() :: [AccountOpeningRequestStatuses.t()]
  defdelegate account_opening_request_statuses, to: AccountOpeningRequestStatuses, as: :list

  defdelegate get_account_opening_request_by_profile_id(profile_id),
    to: AccountOpeningRequests,
    as: :get_by_profile_id

  @doc """
  Gets the profile's account opening request or creates one if none exists.
  """
  @spec get_or_create_account_opening_request(Ecto.UUID.t(), Ecto.UUID.t() | none()) ::
          {:ok, AccountOpeningRequest.t()} | {:error, :changeset, map()}
  defdelegate get_or_create_account_opening_request(profile_id, referrer_id \\ nil),
    to: AccountOpeningRequests,
    as: :get_or_create

  defdelegate complete_account_opening_request(account_opening_request),
    to: AccountOpeningRequests,
    as: :complete

  defdelegate complete_account_opening_request?(account_opening_request),
    to: AccountOpeningRequests,
    as: :complete?

  @doc """
  Lists complete accounts created from a referral.
  """
  @spec list_complete_referred_accounts(Ecto.UUID.t()) :: [Account.t()] | []
  def list_complete_referred_accounts(referrer_id) do
    referrer_id
    |> AccountOpeningRequests.list_done_by_referrer_id()
    |> Enum.map(&AccountOpeningRequests.to_account/1)
  end
end
