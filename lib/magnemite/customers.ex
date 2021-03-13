defmodule Magnemite.Customers do
  @moduledoc """
  Internal API for Customers.
  """

  alias __MODULE__.{
    Profile,
    Profiles,
    ReferralCodes,
  }

  defdelegate get_profile(profile_id), to: Profiles, as: :get
  defdelegate get_profile_by_user_id(user_id), to: Profiles, as: :get_by_user_id

  @doc """
  Checks if a profile has all of its fields filled up.
  """
  @spec complete_profile?(Profile.t()) :: boolean()
  defdelegate complete_profile?(profile), to: Profiles, as: :complete?

  @doc """
  Gets a referral code for a profile or creates one if none exists.
  """
  @spec get_or_create_referral_code(Ecto.UUID.t()) ::
          {:ok, ReferralCode.t()} | {:error, :changeset, map()}
  defdelegate get_or_create_referral_code(profile_id), to: ReferralCodes, as: :get_or_create

  @doc """
  Gets a profile by their referral code number.
  """
  @spec get_referrer(String.t() | nil) :: {:ok, Profile.t()} | {:error, :invalid_referral_code}
  def get_referrer(referral_code_number) when is_binary(referral_code_number) do
    referral_code_number
    |> Profiles.get_by_referral_code()
    |> case do
      {:error, _} -> {:error, :invalid_referral_code}
      success -> success
    end
  end

  @doc """
  Creates a profile for a user or updates one if none exists.
  """
  @spec upsert_profile_by_user_id(String.t(), Enum.t()) ::
          {:ok, Profile.t()} | {:error, :changeset, map()}
  defdelegate upsert_profile_by_user_id(user_id, params), to: Profiles, as: :upsert_by_user_id
end
