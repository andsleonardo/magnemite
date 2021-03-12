defmodule Magnemite.Customers.ReferralCodeQuery do
  @moduledoc false

  alias Magnemite.Customers.ReferralCode

  import Ecto.Query

  def numbers do
    select(ReferralCode, [rc], rc.number)
  end
end
