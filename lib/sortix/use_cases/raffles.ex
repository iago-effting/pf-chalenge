defmodule Sortix.UseCases.Raffles do
  alias Ecto.Multi

  alias Sortix.Domain.Service.CreateRaffle
  alias Sortix.Infrastructure.Jobs.Raffles.DrawRaffleJob
  alias Sortix.Infrastructure.Repo

  def create_raffle(attrs) do
    Multi.new()
    |> Multi.run(:raffle, fn _repo, _changes -> CreateRaffle.call(attrs) end)
    |> Multi.run(:job, &create_raffle_draw_job/2)
    |> Repo.transaction()
    |> handle_transaction()
  end

  defp create_raffle_draw_job(_repo, %{raffle: raffle}) do
    %{raffle_id: raffle.id}
    |> DrawRaffleJob.new(scheduled_at: raffle.draw_date)
    |> Oban.insert()
  end

  defp handle_transaction({:ok, %{raffle: raffle}}), do: {:ok, raffle}
  defp handle_transaction({:error, _step, reason, _}), do: {:error, reason}
end
