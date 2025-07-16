defmodule Sortix.Domain.Raffles.Services.DrawTest do
  use Sortix.DataCase, async: true

  alias Sortix.Domain.Raffles.Services.Draw
  alias Sortix.UseCases.Raffles

  describe "call/1" do
    test "draw returns a winner" do
      {:ok, raffle} = raffle_fixure()
      {:ok, another_raffle} = raffle_fixure()

      assert raffle.winner_user_id == nil
      assert raffle.status == :open

      users = insert_participations(raffle.id, 5)
      _other_users = insert_participations(another_raffle.id, 10)

      assert {:ok, winner_id} = Draw.call(raffle.id)
      assert winner_id in Enum.map(users, & &1.id)

      raffle = raffle |> Repo.reload() |> Repo.preload(:winner_user)
      assert raffle.winner_user_id == winner_id
      assert raffle.status == :drawn
    end

    test "draw raffle without participants" do
      {:ok, raffle} = raffle_fixure()
      assert {:error, :no_participants} = Draw.call(raffle.id)
    end
  end

  defp insert_participations(raffle_id, n) do
    Enum.map(1..n, fn _ ->
      {:ok, user} = user_fixure()
      :ok = Raffles.enter_raffle(raffle_id, user.id)
      user
    end)
  end
end
