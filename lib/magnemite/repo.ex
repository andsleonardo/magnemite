defmodule Magnemite.Repo do
  use Ecto.Repo,
    otp_app: :magnemite,
    adapter: Ecto.Adapters.Postgres
end
