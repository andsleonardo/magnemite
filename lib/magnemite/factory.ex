defmodule Magnemite.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Magnemite.Repo

  use Magnemite.Factories.{
    AddressFactory,
    CustomerFactory,
    AccountOpeningRequestFactory
  }
end
