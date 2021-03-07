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
         {:ok, referrer} <- maybe_get_referrer(account_opening_data),
         {:ok, account_opening} <- request_account_opening(customer, referrer),
         {:ok, account_opening} <- maybe_complete_account_opening(account_opening, customer),
         :ok <- maybe_generate_referral_code(customer, account_opening) do
      {:ok, build_account(customer, referrer, account_opening)}
    end
  end

  defp transform_address_params(%{} = account_opening_data) do
    {address, account_opening_data} = Map.split(account_opening_data, [:city, :country, :state])
    Map.merge(account_opening_data, %{address: address})
  end

  defp maybe_get_referrer(account_opening_data) do
    account_opening_data
    |> Map.get(:referral_code)
    |> case do
      nil -> {:ok, nil}
      number -> Customers.get_referrer(number)
    end
  end

  defp request_account_opening(customer, nil) do
    Accounts.request_account_opening(customer.id)
  end

  defp request_account_opening(customer, referrer) do
    Accounts.request_account_opening(customer.id, referrer.id)
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

  defp maybe_generate_referral_code(customer, %{status: :pending}), do: :ok

  defp maybe_generate_referral_code(customer, %{status: :complete}) do
    with {:ok, _} <- Customers.get_or_create_referral_code(customer), do: :ok
  end

  defp build_account(customer, referrer, account_opening) do
    customer = Repo.preload(customer, [:address, :referral_code])
    struct(Account, %{customer: customer, referrer: referrer, status: account_opening.status})
  end
end
