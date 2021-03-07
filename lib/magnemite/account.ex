defmodule Magnemite.Account do
  @moduledoc false

  @enforce_keys [:status]
  defstruct [:status, :referral_code]
end
