defmodule Sortix.Infrastructure.Jobs.RaffleParticipationJob do
  use Oban.Worker, queue: :pariticipations

  alias Sortix.UseCases.Raffles

  @impl true
  def perform(%Oban.Job{args: %{"raffle_id" => raffle_id, "user_id" => user_id}}) do
    dbg()
    Raffles.enter_raffle(raffle_id, user_id)
  end
end
