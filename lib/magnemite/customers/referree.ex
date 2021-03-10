defmodule Magnemite.Customers.Referree do
  @moduledoc false

  @enforce_keys [:account_id, :name]
  defstruct [:account_id, :name]
end
