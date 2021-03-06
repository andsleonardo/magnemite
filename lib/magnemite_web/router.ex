defmodule MagnemiteWeb.Router do
  use MagnemiteWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug MagnemiteWeb.AuthPipeline
  end

  scope "/api", MagnemiteWeb.Api do
    pipe_through :api_auth

    scope "/v1", V1 do
      post "/accounts", AccountController, :open_account
      get "/accounts/referred", AccountController, :list_referred
    end
  end

  scope "/api", MagnemiteWeb.Api do
    pipe_through :api

    scope "/v1", V1 do
      post "/users/sign_up", UserController, :sign_up
      post "/users/sign_in", UserController, :sign_in
    end
  end
end
