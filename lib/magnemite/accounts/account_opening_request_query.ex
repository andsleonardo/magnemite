defmodule Magnemite.Accounts.AccountOpeningRequestQuery do
  @moduledoc false

  alias Magnemite.Accounts
  alias Magnemite.Accounts.{AccountOpeningRequest, AccountOpeningRequestStatuses}

  import Ecto.Query

  def done_by_referrer_id(referrer_id) do
    AccountOpeningRequest
    |> where([aor], aor.status == ^AccountOpeningRequestStatuses.done())
    |> where([aor], aor.referrer_id == ^referrer_id)
    |> preload([aor], :profile)
  end
end
