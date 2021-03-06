defmodule Magnemite.Account do
  @moduledoc false

  @enforce_keys [:customer, :status]
  defstruct [:customer, :status]
end
