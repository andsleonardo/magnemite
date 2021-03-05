defmodule MagnemiteWeb.Router do
  use MagnemiteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MagnemiteWeb do
    pipe_through :api
  end
end
