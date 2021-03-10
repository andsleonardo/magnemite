defmodule Magnemite.Accounts.Account do
  @moduledoc false

  @enforce_keys [:status, :referral_code]
  defstruct [:status, :referral_code]
end
