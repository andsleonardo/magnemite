defmodule Magnemite.Customers do
  @moduledoc """
  Internal API for Customers.
  """

  alias __MODULE__.{
    AddressValidator,
    Customer,
    CustomerValidator,
    GenderOptions,
    ReferralCode,
    ReferralCodeGenerator,
    Referree
  }

  alias Magnemite.Repo

  import Ecto.Query

  # CUSTOMER

  @doc """
  Lists gender options for customers.
  """
  @spec gender_options() :: [GenderOptions.t()]
  defdelegate gender_options, to: GenderOptions, as: :list

  @doc """
  Lists all customers.
  """
  @spec list_customers() :: [Customer.t()] | []
  def list_customers do
    Repo.all(Customer)
  end

  @doc """
  Gets a `%Magnemite.Customers.Customer{}` if any matches the given `id`.
  """
  @spec get_customer(Ecto.UUID.t()) :: {:ok, Customer.t()} | {:error, :customer_not_found}
  def get_customer(id) do
    Customer
    |> Repo.get(id)
    |> case do
      nil -> {:error, :customer_not_found}
      customer -> {:ok, customer}
    end
  end

  @doc """
  Gets a `%Magnemite.Customers.Customer{}` if any meets the given `criteria`.
  """
  @spec get_customer_by(Keyword.t()) :: {:ok, Customer.t()} | {:error, :customer_not_found}
  def get_customer_by(criteria) do
    Customer
    |> Repo.get_by(criteria)
    |> case do
      nil -> {:error, :customer_not_found}
      customer -> {:ok, customer}
    end
  end

  @doc """
  Gets a `%Magnemite.Customers.Customer{}` by its `referral_code_number`.
  """
  @spec get_referrer(String.t() | nil) :: {:ok, Customer.t()} | {:error, :invalid_referral_code}
  def get_referrer(nil), do: {:error, :invalid_referral_code}

  def get_referrer(referral_code_number) do
    Customer
    |> join(:left, [c], rc in assoc(c, :referral_code))
    |> where([_, rc], rc.number == ^referral_code_number)
    |> Repo.one()
    |> case do
      nil -> {:error, :invalid_referral_code}
      customer -> {:ok, customer}
    end
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
    |> Repo.get_by(cpf_hash: cpf)
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

  @doc """
  Checks if a `%Magnemite.Customers.Customer{}` has all of its fields filled up.
  """
  @spec complete_customer_with_address?(Customer.t()) :: boolean()
  def complete_customer_with_address?(customer) do
    CustomerValidator.complete_customer?(customer) &&
      AddressValidator.complete_address?(customer.address)
  end

  # REFERRAL CODE

  defdelegate generate_referral_code_number(), to: ReferralCodeGenerator, as: :generate_number

  @doc """
  Lists all persisted referral code numbers.
  """
  @spec list_referral_codes_numbers() :: [String.t()] | []
  def list_referral_codes_numbers do
    ReferralCode
    |> select([rc], rc.number)
    |> Repo.all()
  end

  @doc """
  Gets a `%Magnemite.Customers.ReferralCode{}` for a customer
  or creates one if no such record exists yet.
  """
  @spec get_or_create_referral_code(Customer.t()) ::
          {:ok, ReferralCode.t()} | {:error, :changeset, map()}
  def get_or_create_referral_code(%Customer{} = customer) do
    ReferralCode
    |> Repo.get_by(customer_id: customer.id)
    |> case do
      nil -> create_referral_code(customer.id)
      referral_code -> {:ok, referral_code}
    end
  end

  defp create_referral_code(customer_id) do
    %ReferralCode{}
    |> ReferralCode.changeset(%{
      customer_id: customer_id,
      number: generate_referral_code_number()
    })
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def build_referree(account_id, referree_name) do
    struct(Referree, account_id: account_id, name: referree_name)
  end
end
