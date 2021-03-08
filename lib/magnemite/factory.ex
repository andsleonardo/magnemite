defmodule Magnemite.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Magnemite.Repo

  use Magnemite.Factories.{
    AccountFactory,
    AccountOpeningRequestFactory,
    AddressFactory,
    CustomerFactory,
    ReferralCodeFactory,
    UserFactory
  }

  defp referral_code_number do
    Nanoid.generate_non_secure(8, "123456789")
  end
end
