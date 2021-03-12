defmodule Magnemite.Accounts.AccountOpeningRequestStatuses do
  @moduledoc false

  @type t :: :done | :pending

  @done_status :done
  @pending_status :pending

  @spec list() :: [t()]
  def list, do: [@done_status, @pending_status]

  @spec pending() :: :pending
  def pending, do: @pending_status

  @spec done() :: :done
  def done, do: @done_status
end
