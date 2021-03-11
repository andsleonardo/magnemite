defmodule Magnemite.Ecto.EncryptedBinary do
  @moduledoc false

  use Cloak.Ecto.Binary, vault: Magnemite.Vault
end
