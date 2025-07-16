defmodule Sortix.Domain.Raffles.Services.Draw do
  alias Sortix.Raffles.Raffle
  alias Sortix.Infrastructure.Repo

  alias Ecto.Multi

  import Ecto.Query

  def call(raffle_id) do
    case draw_participant(raffle_id) do
      {:ok, user_id} ->
        Multi.new()
        |> Multi.run(:raffle, fn _repo, _ -> get_raffle(raffle_id) end)
        |> Multi.update(:update_raffle, fn %{raffle: raffle} ->
          Raffle.put_winner(raffle, user_id)
        end)
        |> Repo.transaction()
        |> case do
          {:ok, _multi} -> {:ok, user_id}
          {:error, _step, reason, _} -> {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp draw_participant(raffle_id) do
    query =
      from(e in "raffle_entries",
        where: e.raffle_id == type(^raffle_id, :binary_id),
        order_by: fragment("RANDOM()"),
        limit: 1,
        select: type(e.user_id, :string)
      )

    case Repo.one(query) do
      nil -> {:error, :no_participants}
      user_id -> {:ok, user_id}
    end
  end

  defp get_raffle(raffle_id) do
    case Repo.get(Raffle, raffle_id) do
      nil -> {:error, :raffle_not_found}
      raffle -> {:ok, raffle}
    end
  end
end
