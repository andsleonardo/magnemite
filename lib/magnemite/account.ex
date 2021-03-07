defmodule Magnemite.Account do
  @moduledoc false

  @enforce_keys [:customer, :referrer, :status]
  defstruct [:customer, :referrer, :status]
end
