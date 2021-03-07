defmodule Magnemite do
  @moduledoc """
  Magnemite's public API.
  """

  alias __MODULE__.{Account, Accounts, Customers}
  alias __MODULE__.Repo

  import Magnemite.Fallback

  @spec get_or_open_account(map()) :: any()
  def get_or_open_account(%{cpf: cpf} = account_opening_data) do
    account_opening_data = transform_address_params(account_opening_data)

    with {:ok, customer} <- Customers.upsert_customer_by_cpf(cpf, account_opening_data),
         {:ok, account_opening} <- request_account_opening(customer, account_opening_data),
         {:ok, account_opening} <- maybe_complete_account_opening(account_opening, customer),
         {:ok, referral_code} <- maybe_generate_referral_code(customer, account_opening) do
      {:ok, build_account(account_opening, referral_code)}
    end
  end

  defp transform_address_params(%{} = account_opening_data) do
    {address, account_opening_data} = Map.split(account_opening_data, [:city, :country, :state])
    Map.merge(account_opening_data, %{address: address})
  end

  defp request_account_opening(customer, %{referral_code: referral_code})
       when not is_nil(referral_code) do
    with {:ok, referrer} <- Customers.get_referrer(referral_code) do
      Accounts.request_account_opening(customer.id)
    end
  end

  defp request_account_opening(customer, _account_opening_data) do
    Accounts.request_account_opening(customer.id)
  end

  defp maybe_complete_account_opening(%{status: :complete} = account_opening, _customer) do
    {:ok, account_opening}
  end

  defp maybe_complete_account_opening(account_opening, customer) do
    if complete_account?(customer) do
      Accounts.complete_account_opening(account_opening)
    else
      {:ok, account_opening}
    end
  end

  defp complete_account?(customer) do
    customer
    |> Repo.preload(:address)
    |> Customers.complete_customer_with_address?()
  end

  defp maybe_generate_referral_code(customer, %{status: :pending}) do
    {:ok, nil}
  end

  defp maybe_generate_referral_code(customer, %{status: :complete}) do
    Customers.get_or_create_referral_code(customer)
  end

  defp build_account(account_opening, nil) do
    struct(Account, %{status: account_opening.status})
  end

  defp build_account(account_opening, referral_code) do
    struct(Account, %{
      referral_code: referral_code.number,
      status: account_opening.status
    })
  end
end
