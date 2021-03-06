defmodule Magnemite.Accounts do
  @moduledoc """
  Internal API for Accounts.
  """

  alias Magnemite.Repo

  alias __MODULE__.{
    AccountOpeningRequest,
    AccountOpeningRequestStatuses
  }

  @doc """
  Gets an account opening request with a customer_id or creates one if it doesn't exist.
  """
  @spec get_or_create_account_opening_request(Ecto.UUID.t()) :: {:ok, AccountOpeningRequest.t()}
  def get_or_create_account_opening_request(customer_id) when not is_nil(customer_id) do
    AccountOpeningRequest
    |> Repo.get_by(customer_id: customer_id)
    |> case do
      nil -> create_account_opening_request(customer_id)
      account_opening_request -> {:ok, account_opening_request}
    end
  end

  defp create_account_opening_request(customer_id) when not is_nil(customer_id) do
    %AccountOpeningRequest{}
    |> AccountOpeningRequest.changeset(%{customer_id: customer_id})
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  defdelegate account_opening_request_statuses,
    to: AccountOpeningRequestStatuses,
    as: :list
end
