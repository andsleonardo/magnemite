defmodule Magnemite.Customers do
  @moduledoc """
  Internal API for Customers.
  """

  use Magnemite.Changeset

  alias __MODULE__.{Customer, GenderOptions}
  alias Magnemite.Repo

  defdelegate gender_options, to: GenderOptions, as: :list

  @doc """
  Lists all customers.
  """
  @spec list_customers() :: [Customer.t()] | []
  def list_customers do
    Repo.all(Customer)
  end

  @doc """
  Creates a `%Magnemite.Customers.Customer{}` with `cpf` and `params`
  or updates one with `params` if there's already a record with `cpf`.
  """
  @spec upsert_customer_by_cpf(String.t(), Enum.t()) :: {:ok, Customer.t()} | {:error, map()}
  def upsert_customer_by_cpf(cpf, params) do
    params =
      params
      |> Map.new()
      |> Map.merge(%{cpf: cpf})

    Customer
    |> Repo.get_by(cpf: cpf)
    |> case do
      nil -> create_customer(params)
      customer -> update_customer(customer, params)
    end
  end

  defp create_customer(params) do
    %Customer{}
    |> change_customer(params, &Customer.creation_changeset/2)
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  defp update_customer(customer, params) do
    customer
    |> change_customer(params, &Customer.update_changeset/2)
    |> Repo.update()
    |> Repo.handle_operation_result()
  end

  defp change_customer(customer, params, changeset_fun) when is_function(changeset_fun) do
    customer
    |> Repo.preload(:address)
    |> changeset_fun.(params)
  end
end
