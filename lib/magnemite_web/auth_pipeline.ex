defmodule MagnemiteWeb.AuthPipeline do
  @moduledoc false

  @claims %{"typ" => "access"}

  use Guardian.Plug.Pipeline,
    otp_app: :magnemite,
    module: Magnemite.Identity.Guardian,
    error_handler: MagnemiteWeb.AuthPipelineErrorHandler

  alias MagnemiteWeb.Plugs

  plug Guardian.Plug.VerifyHeader, claims: @claims, realm: :none
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug Plugs.AssignUser
end
