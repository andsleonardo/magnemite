defmodule Magnemite.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :magnemite,
    adapter: Ecto.Adapters.Postgres

  import Magnemite.Changeset

  def handle_operation_result({:ok, _record} = output), do: output

  def handle_operation_result({:error, %Ecto.Changeset{} = changeset}) do
    {:error, :changeset, errors_on(changeset)}
  end
end
