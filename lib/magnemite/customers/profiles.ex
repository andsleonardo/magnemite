defmodule Magnemite.Customers.Profiles do
  @moduledoc false

  alias Magnemite.Customers.{Profile, ProfileQuery, ProfileValidator}
  alias Magnemite.Repo

  def list do
    Repo.all(Profile)
  end

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

  def create(params) do
    %Profile{}
    |> Profile.creation_changeset(params)
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end

  def update(profile, params) do
    profile
    |> Repo.preload(:address)
    |> Profile.update_changeset(params)
    |> Repo.update()
    |> Repo.handle_operation_result()
  end

  def complete?(%Profile{} = profile) do
    profile
    |> Repo.preload(:address)
    |> ProfileValidator.complete?()
  end
end
