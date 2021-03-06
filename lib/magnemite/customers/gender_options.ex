defmodule Magnemite.Customers.GenderOptions do
  @moduledoc false

  @gender_options [
    :female,
    :male,
    :non_binary,
    :other,
    :rather_not_say,
    :transgender
  ]

  @spec list() :: [atom()]
  def list, do: @gender_options
end
