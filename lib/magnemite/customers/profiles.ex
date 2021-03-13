defmodule Magnemite.Customers.Profiles do
  @moduledoc false

  alias Magnemite.Customers.{Profile, ProfileQuery, ProfileValidator}
  alias Magnemite.Repo

  def get(id) do
    Profile
    |> Repo.get(id)
    |> case do
      nil -> {:error, :profile_not_found}
      profile -> {:ok, profile}
    end
  end

  def get_by_user_id(user_id) do
    Profile
    |> Repo.get_by(user_id: user_id)
    |> case do
      nil -> {:error, :profile_not_found}
      profile -> {:ok, profile}
    end
  end

  def get_by_referral_code(referral_code_number) do
    referral_code_number
    |> ProfileQuery.by_referral_code()
    |> Repo.one()
    |> case do
      nil -> {:error, :profile_not_found}
      profile -> {:ok, profile}
    end
  end

  def upsert_by_user_id(user_id, params) do
    user_id
    |> get_by_user_id()
    |> case do
      {:error, _} ->
        params
        |> Map.put(:user_id, user_id)
        |> create()

      {:ok, profile} ->
        update(profile, params)
    end
  end

  def create(params) do
    %Profile{}
    |> Profile.creation_changeset(transform_address_params(params))
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def update(profile, params) do
    profile
    |> Repo.preload(:address)
    |> Profile.update_changeset(transform_address_params(params))
    |> Repo.update()
    |> Repo.handle_operation_result()
  end

  defp transform_address_params(params) do
    {address, params} =
      params
      |> Map.new()
      |> Map.split([:city, :country, :state])

    Map.merge(params, %{address: address})
  end

  def complete?(%Profile{} = profile) do
    profile
    |> Repo.preload(:address)
    |> ProfileValidator.complete?()
  end
end
