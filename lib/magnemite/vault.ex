defmodule Magnemite.Vault do
  @moduledoc false

  use Cloak.Vault, otp_app: :magnemite

  @impl GenServer
  def init(config) do
    config =
      config
      |> Keyword.put(:ciphers,
        default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: decode_env!("CLOAK_SECRET_KEY")}
      )

    {:ok, config}
  end

  defp decode_env!(var) do
    var
    |> System.get_env()
    |> Base.decode64!()
  end
end
