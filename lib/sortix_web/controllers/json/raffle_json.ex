defmodule SortixWeb.RaffleJSON do
  def raffle(%{raffle: raffle}) do
    %{
      id: raffle.id,
      name: raffle.name,
      draw_date: raffle.draw_date,
      status: raffle.status,
      winner: winner_json(raffle.winner_user)
    }
  end

  defp winner_json(nil), do: nil

  defp winner_json(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
