defmodule Sortix.Domain.Service.CreateRaffle do
  alias Sortix.Infrastructure.Repo
  alias Sortix.Raffles.Raffle

  def call(attrs) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end
end
