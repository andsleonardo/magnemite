defmodule Magnemite.Customers.Referrees do
  @moduledoc false

  alias Magnemite.Customers.Referree

  def build(account_id, referree_name) do
    Referree
    |> struct(account_id: account_id, name: referree_name)
  end
end
