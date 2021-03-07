defmodule Magnemite.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Magnemite.Repo

  use Magnemite.Factories.{
    AccountOpeningRequestFactory,
    AddressFactory,
    CustomerFactory,
    ReferralCodeFactory
  }
end
