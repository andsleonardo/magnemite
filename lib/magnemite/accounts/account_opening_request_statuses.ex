defmodule Magnemite.Accounts.AccountOpeningRequestStatuses do
  @moduledoc false

  @complete :complete
  @pending :pending

  @statuses [@complete, @pending]

  @spec list() :: [atom()]
  def list, do: @statuses

  @spec pending() :: :pending
  def pending, do: @pending
end
