defmodule MagnemiteWeb.AuthPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline,
    otp_app: :magnemite,
    module: Magnemite.Identity.Guardian,
    error_handler: MagnemiteWeb.AuthPipelineErrorHandler

  plug Guardian.Plug.EnsureAuthenticated
end
