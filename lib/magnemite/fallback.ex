defmodule Magnemite.Fallback do
  @moduledoc false

  @doc """
  An easy-to-pipe function that handles any incoming value,
  fallbacking to the second argument if the first one is `nil`.
  """
  @spec fallback_to(any(), any()) :: any()
  def fallback_to(nil, fallback), do: fallback
  def fallback_to(anything, _fallback), do: anything
end
