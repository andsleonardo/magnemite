defmodule Magnemite.Customers.ReferralCodes do
  @moduledoc false

  alias Magnemite.Customers.{ReferralCode, ReferralCodeGenerator, ReferralCodeQuery}
  alias Magnemite.Repo

  def list_numbers do
    Repo.all(ReferralCodeQuery.numbers())
  end

  def get_or_create(profile_id) do
    ReferralCode
    |> Repo.get_by(profile_id: profile_id)
    |> case do
      nil -> create(profile_id)
      referral_code -> {:ok, referral_code}
    end
  end

  def create(profile_id) do
    %ReferralCode{}
    |> ReferralCode.changeset(
      profile_id: profile_id,
      number: ReferralCodeGenerator.generate_number()
    )
    |> Repo.insert()
    |> Repo.handle_operation_result()
  end
end
