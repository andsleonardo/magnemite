defmodule Magnemite.Ecto.EncryptedDate do
  @moduledoc false

  use Cloak.Ecto.Date, vault: Magnemite.Vault
end
