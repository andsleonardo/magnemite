defmodule Magnemite.Accounts.AccountOpeningRequests do
  @moduledoc false

  alias Magnemite.Accounts.{
    Account,
    AccountOpeningRequest,
    AccountOpeningRequestQuery,
    AccountOpeningRequestStatuses
  }

  alias Magnemite.Repo

  def list_done_by_referrer_id(referrer_id) do
    referrer_id
    |> AccountOpeningRequestQuery.done_by_referrer_id()
    |> Repo.all()
  end

  def get_by_profile_id(profile_id) do
    AccountOpeningRequest
    |> Repo.get_by(profile_id: profile_id)
    |> case do
      nil -> {:error, :account_opening_request_not_found}
      account_opening_request -> {:ok, account_opening_request}
    end
  end

  def get_or_create(profile_id, referrer_id \\ nil) do
    profile_id
    |> get_by_profile_id()
    |> case do
      {:error, _} -> create(profile_id: profile_id, referrer_id: referrer_id)
      success -> success
    end
  end

  defp create(params) do
    %AccountOpeningRequest{}
    |> AccountOpeningRequest.changeset(params)
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def complete?(%AccountOpeningRequest{} = account_opening_request) do
    account_opening_request.status == AccountOpeningRequestStatuses.done()
  end

  def complete(%AccountOpeningRequest{} = account_opening_request) do
    update(account_opening_request, status: AccountOpeningRequestStatuses.done())
  end

  defp update(%AccountOpeningRequest{} = account_opening_request, params) do
    account_opening_request
    |> AccountOpeningRequest.changeset(params)
    |> Repo.update()
    |> Repo.handle_operation_result()
  end

  def to_account(%AccountOpeningRequest{} = account_opening_request) do
    account_opening_request = Repo.preload(account_opening_request, :profile)

    Account
    |> struct(%{
      id: account_opening_request.id,
      name: Map.get(account_opening_request.profile, :name),
      referral_code: Map.get(account_opening_request.profile, :referral_code),
      status: account_opening_request.status
    })
  end
end
