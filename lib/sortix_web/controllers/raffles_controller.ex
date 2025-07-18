defmodule SortixWeb.RafflesController do
  use SortixWeb, :controller

  alias Sortix.Raffles.Raffle
  alias Sortix.UseCases.Raffles

  def create(conn, %{"name" => name, "draw_date" => draw_date}) do
    with {:ok, naive} <- NaiveDateTime.from_iso8601(draw_date),
         {:ok, dt} <- DateTime.from_naive(naive, "America/Sao_Paulo"),
         {:ok, raffle} <- Raffles.create_raffle(%{name: name, draw_date: dt}) do
      json(conn, %{id: raffle.id})
    else
      {:error, %Ecto.Changeset{} = cs} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(cs)})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid input"})
    end
  end

  def show(conn, %{"id" => raffle_id}) do
    case Raffles.get_result(raffle_id) do
      {:error, :not_found} ->
        send_resp(conn, 404, "Raffle not found")

      {:ok, %Raffle{status: :drawn} = raffle} ->
        conn
        |> put_view(SortixWeb.WinnerJSON)
        |> render(:winner, %{winner: raffle.winner_user})

      {:ok, %Raffle{} = _raffle} ->
        conn
        |> put_status(:conflict)
        |> json(%{message: "Not drawn yet"})
    end
  end

  defp translate_errors(cs) do
    Ecto.Changeset.traverse_errors(cs, fn {msg, _opts} -> msg end)
  end
end
