defmodule Magnemite.Customers.GenderOptions do
  @moduledoc false

  @type t :: :female | :male | :non_binary | :other | :rather_not_say | :transgender

  @gender_options [
    :female,
    :male,
    :non_binary,
    :other,
    :rather_not_say,
    :transgender
  ]

  @spec list() :: [t()]
  def list, do: @gender_options
end
