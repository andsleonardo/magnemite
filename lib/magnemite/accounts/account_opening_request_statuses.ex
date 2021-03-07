defmodule Magnemite.Accounts.AccountOpeningRequestStatuses do
  @moduledoc false

  @type t :: :complete | :pending

  @complete_status :complete
  @pending_status :pending

  @spec list() :: [t()]
  def list, do: [@complete_status, @pending_status]

  @spec pending() :: :pending
  def pending, do: @pending_status
end
