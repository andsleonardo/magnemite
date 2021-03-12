defmodule Magnemite do
  @moduledoc """
  Magnemite's public API.
  """

  alias __MODULE__.{Accounts, Customers, Identity}
  alias __MODULE__.Repo

  defdelegate sign_user_up(username, password), to: Identity, as: :sign_up
  defdelegate sign_user_in(username, password), to: Identity, as: :sign_in

  def list_referrees(referrer_id) do
    with {:ok, referrer} <- Customers.get_profile(referrer_id),
         {:ok, referrer} <- validate_profile_opened_account(referrer) do
      referrals =
        referrer.id
        |> Accounts.list_complete_account_opening_requests()
        |> Enum.map(&Customers.build_referree(&1.id, &1.profile.name))

      {:ok, referrals}
    end
  end

  defp validate_profile_opened_account(profile) do
    profile.id
    |> Accounts.request_account_opening()
    |> case do
      {:ok, %{status: :complete}} -> {:ok, profile}
      _ -> {:error, :incomplete_account_opening_request}
    end
  end

  @spec get_or_open_account(Ecto.UUID.t(), map()) :: any()
  def get_or_open_account(user_id, account_opening_data) do
    account_opening_data = transform_address_params(account_opening_data)

    with {:ok, profile} <- Customers.upsert_profile(user_id, account_opening_data),
         {:ok, account_opening} <- request_account_opening(profile, account_opening_data),
         {:ok, account_opening} <- maybe_complete_account_opening(account_opening, profile),
         {:ok, referral_code} <- maybe_generate_referral_code(profile, account_opening) do
      {:ok, Accounts.build_account(account_opening.status, referral_code.number)}
    end
  end

  defp transform_address_params(%{} = account_opening_data) do
    {address, account_opening_data} = Map.split(account_opening_data, [:city, :country, :state])
    Map.merge(account_opening_data, %{address: address})
  end

  defp request_account_opening(profile, %{referral_code: referral_code})
       when not is_nil(referral_code) do
    with {:ok, referrer} <- Customers.get_referrer(referral_code) do
      Accounts.request_account_opening(profile.id, referrer.id)
    end
  end

  defp request_account_opening(profile, _account_opening_data) do
    Accounts.request_account_opening(profile.id)
  end

  defp maybe_complete_account_opening(%{status: :complete} = account_opening, _profile) do
    {:ok, account_opening}
  end

  defp maybe_complete_account_opening(account_opening, profile) do
    if complete_account?(profile) do
      Accounts.complete_account_opening(account_opening)
    else
      {:ok, account_opening}
    end
  end

  defp complete_account?(profile) do
    profile
    |> Repo.preload(:address)
    |> Customers.complete_profile_with_address?()
  end

  defp maybe_generate_referral_code(_profile, %{status: :pending}) do
    {:ok, %Customers.ReferralCode{}}
  end

  defp maybe_generate_referral_code(profile, %{status: :complete}) do
    Customers.get_or_create_referral_code(profile)
  end
end
