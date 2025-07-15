defmodule Sortix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SortixWeb.Telemetry,
      Sortix.Repo,
      {DNSCluster, query: Application.get_env(:sortix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sortix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sortix.Finch},
      # Start a worker by calling: Sortix.Worker.start_link(arg)
      # {Sortix.Worker, arg},
      # Start to serve requests, typically the last entry
      SortixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sortix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SortixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
