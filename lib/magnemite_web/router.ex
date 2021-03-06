defmodule MagnemiteWeb.Router do
  use MagnemiteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MagnemiteWeb.Api do
    pipe_through :api

    scope "/v1", V1 do
      resources "/accounts", AccountController, only: [:create]
    end
  end
end
