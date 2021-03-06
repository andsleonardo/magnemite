defmodule Magnemite.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :magnemite,
    adapter: Ecto.Adapters.Postgres

  def handle_operation_result({:ok, record} = output), do: output

  def handle_operation_result({:error, %Ecto.Changeset{} = changeset}) do
    {:error, Magnemite.Changeset.errors_on(changeset)}
  end
end
