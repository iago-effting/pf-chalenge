defmodule Sortix.Infrastructure.Jobs.RaffleDrawJob do
  use Oban.Worker, queue: :draws

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"raffle_id" => raffle_id}}) do
    Sortix.UseCases.Raffles.draw_raffle(raffle_id)
  end
end
