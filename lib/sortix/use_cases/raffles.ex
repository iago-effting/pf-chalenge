defmodule Sortix.UseCases.Raffles do
  alias Sortix.Raffles.Raffle
  alias Ecto.Multi

  alias Sortix.Domain.Raffles.Participation
  alias Sortix.Domain.Service.CreateRaffle
  alias Sortix.Infrastructure.Jobs.RaffleParticipationJob
  alias Sortix.Infrastructure.Jobs.RaffleDrawJob
  alias Sortix.Infrastructure.Repo

  def create_raffle(attrs) do
    Multi.new()
    |> Multi.run(:raffle, fn _repo, _changes -> CreateRaffle.call(attrs) end)
    |> Multi.run(:job, &enqueue_raffle_draw_job/2)
    |> Repo.transaction()
    |> handle_transaction()
  end

  def enqueue_raffle_participation(raffle_id, user_id) do
    %{"raffle_id" => raffle_id, "user_id" => user_id}
    |> RaffleParticipationJob.new()
    |> Oban.insert()
  end

  def enter_raffle(raffle_id, user_id) do
    %{raffle_id: raffle_id, user_id: user_id}
    |> Participation.register()
    |> Repo.insert(on_conflict: :nothing)
    |> case do
      {:ok, _} -> :ok
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp enqueue_raffle_draw_job(_repo, %{raffle: raffle}) do
    %{raffle_id: raffle.id}
    |> RaffleDrawJob.new(scheduled_at: raffle.draw_date)
    |> Oban.insert()
  end

  def draw_raffle(raffle_id) do
    raffle_id
    |> Sortix.Domain.Raffles.Services.Draw.call()
    |> case do
      {:ok, winner_id} -> {:ok, winner_id}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_result(raffle_id) do
    case Repo.get(Raffle, raffle_id) do
      nil ->
        {:error, :not_found}

      %Raffle{} = raffle ->
        {:ok, Repo.preload(raffle, :winner_user)}
    end
  end

  defp handle_transaction({:ok, %{raffle: raffle}}), do: {:ok, raffle}
  defp handle_transaction({:error, _step, reason, _}), do: {:error, reason}
end
