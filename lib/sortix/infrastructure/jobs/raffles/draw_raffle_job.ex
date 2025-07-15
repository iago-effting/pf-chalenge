defmodule Sortix.Infrastructure.Jobs.Raffles.DrawRaffleJob do
  use Oban.Worker, queue: :draws

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"raffle_id" => _raffle_id}}) do
    # Sortix.UseCases.Raffles.draw_raffle(raffle_id)
    :ok
  end
end
