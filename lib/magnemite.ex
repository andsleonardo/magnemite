defmodule Magnemite do
  @moduledoc """
  Magnemite's public API.
  """

  alias __MODULE__.{Accounts, Customers, Identity}

  defdelegate sign_user_up(username, password), to: Identity, as: :sign_up
  defdelegate sign_user_in(username, password), to: Identity, as: :sign_in
  defdelegate get_profile_by_user_id(user_id), to: Customers

  def list_referred_accounts(user_id) do
    with {:ok, referrer} <- Customers.get_profile_by_user_id(user_id),
         {:ok, account_opening_request} <-
           Accounts.get_account_opening_request_by_profile_id(referrer.id) do
      if Accounts.complete_account_opening_request?(account_opening_request) do
        {:ok, Accounts.list_complete_referred_accounts(referrer.id)}
      else
        {:error, :incomplete_account_opening_request}
      end
    end
  end

  @spec get_or_open_account(Ecto.UUID.t(), map()) :: any()
  def get_or_open_account(user_id, account_opening_data) do
    with {:ok, profile} <- Customers.upsert_profile_by_user_id(user_id, account_opening_data),
         {:ok, account_opening} <- request_account_opening(profile, account_opening_data),
         {:ok, account_opening} <- complete_account_opening(account_opening, profile),
         {:ok, referral_code} <- generate_referral_code(profile, account_opening) do
      {:ok, build_account(account_opening, profile, referral_code)}
    end
  end

  defp request_account_opening(profile, %{referral_code: referral_code})
       when not is_nil(referral_code) do
    with {:ok, referrer} <- Customers.get_referrer(referral_code) do
      Accounts.get_or_create_account_opening_request(profile.id, referrer.id)
    end
  end

  defp request_account_opening(profile, _account_opening_data) do
    Accounts.get_or_create_account_opening_request(profile.id)
  end

  defp complete_account_opening(account_opening, profile) do
    if Customers.complete_profile?(profile) do
      Accounts.complete_account_opening_request(account_opening)
    else
      {:ok, account_opening}
    end
  end

  defp generate_referral_code(profile, account_opening_request) do
    if Accounts.complete_account_opening_request?(account_opening_request) do
      Customers.get_or_create_referral_code(profile.id)
    else
      {:ok, %{}}
    end
  end

  defp build_account(account_opening_request, profile, referral_code) do
    account_opening_request
    |> Map.from_struct()
    |> Map.merge(%{
      name: profile.name,
      referral_code: Map.get(referral_code, :number)
    })
  end
end
