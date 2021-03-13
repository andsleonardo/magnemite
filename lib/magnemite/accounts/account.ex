defmodule Magnemite.Accounts.Account do
  @moduledoc false

  @enforce_keys [:id, :name, :status]
  defstruct [:id, :name, :referral_code, :status]
end
