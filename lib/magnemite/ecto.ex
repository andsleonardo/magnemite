defmodule Magnemite.Ecto do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Magnemite.Ecto.{EncryptedBinary, EncryptedDate}
    end
  end
end
