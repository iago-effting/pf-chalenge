defmodule Sortix.Infrastructure.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SortixWeb.Telemetry,
      Sortix.Infrastructure.Repo,
      {DNSCluster, query: Application.get_env(:sortix, :dns_cluster_query) || :ignore},
      {Oban, Application.fetch_env!(:sortix, Oban)},
      {Phoenix.PubSub, name: Sortix.PubSub},
      {Finch, name: Sortix.Finch},
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
