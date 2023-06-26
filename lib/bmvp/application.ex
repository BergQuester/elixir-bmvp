defmodule Bmvp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BmvpWeb.Telemetry,
      # Start the Ecto repository
      Bmvp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bmvp.PubSub},
      # Start Finch
      {Finch, name: Bmvp.Finch},
      # Start the Endpoint (http/https)
      BmvpWeb.Endpoint
      # Start a worker by calling: Bmvp.Worker.start_link(arg)
      # {Bmvp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bmvp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BmvpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
