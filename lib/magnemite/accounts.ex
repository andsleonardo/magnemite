defmodule Magnemite.Accounts do
  @moduledoc """
  Internal API for Accounts.
  """

  alias __MODULE__.{
    Account,
    AccountOpeningRequest,
    AccountOpeningRequestStatuses
  }

  alias Magnemite.Repo

  import Ecto.Query

  # ACCOUNT OPENING REQUEST

  @doc """
  Lists the possible account opening request statuses.
  """
  @spec account_opening_request_statuses() :: [AccountOpeningRequestStatuses.t()]
  defdelegate account_opening_request_statuses, to: AccountOpeningRequestStatuses, as: :list

  @doc """
  Lists account opening requests having the given `referrer_id` and a `complete` status.
  """
  @spec list_complete_account_opening_requests(Ecto.UUID.t()) :: [AccountOpeningRequest.t()] | []
  def list_complete_account_opening_requests(referrer_id) do
    AccountOpeningRequest
    |> where([aor], aor.referrer_id == ^referrer_id)
    |> where([aor], aor.status == :complete)
    |> preload([_], :customer)
    |> Repo.all()
  end

  @doc """
  Gets an account opening request with a customer_id or creates one if it doesn't exist.
  """
  @spec request_account_opening(Ecto.UUID.t(), Ecto.UUID.t() | none()) ::
          {:ok, AccountOpeningRequest.t()} | {:error, :changeset, map()}
  def request_account_opening(customer_id, referrer_id \\ nil) when not is_nil(customer_id) do
    AccountOpeningRequest
    |> Repo.get_by(customer_id: customer_id)
    |> case do
      nil -> create_account_opening_request(customer_id, referrer_id)
      account_opening_request -> {:ok, account_opening_request}
    end
  end

  defp create_account_opening_request(customer_id, referrer_id) do
    params = %{customer_id: customer_id, referrer_id: referrer_id}

    %AccountOpeningRequest{}
    |> AccountOpeningRequest.changeset(params)
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  @doc """
  Changes the status of an account opening request to `:complete`
  if that's not the record's status yet.
  """
  @spec complete_account_opening(AccountOpeningRequest.t()) ::
          {:ok, AccountOpeningRequest.t()} | {:error, :changeset, map()}
  def complete_account_opening(
        %AccountOpeningRequest{status: :complete} = account_opening_request
      ) do
    {:ok, account_opening_request}
  end

  def complete_account_opening(%AccountOpeningRequest{} = account_opening_request) do
    update_account_opening_request(account_opening_request, %{status: :complete})
  end

  defp update_account_opening_request(account_opening_request, params) do
    account_opening_request
    |> __MODULE__.AccountOpeningRequest.changeset(params)
    |> Repo.update()
    |> Repo.handle_operation_result()
  end

  def build_account(status, referral_code \\ nil) do
    struct(Account, %{status: status, referral_code: referral_code})
  end
end
