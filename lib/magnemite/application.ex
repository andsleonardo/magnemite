defmodule Magnemite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Magnemite.Repo,
      # Start the Telemetry supervisor
      MagnemiteWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Magnemite.PubSub},
      # Start the Endpoint (http/https)
      MagnemiteWeb.Endpoint,
      # Start the encryption application
      Magnemite.Vault
      # Start a worker by calling: Magnemite.Worker.start_link(arg)
      # {Magnemite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Magnemite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MagnemiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
