defmodule SortixWeb.ParticipationController do
  use SortixWeb, :controller

  alias Sortix.UseCases.Raffles

  def create(conn, %{"raffle_id" => raffle_id, "user_id" => user_id}) do
    case Raffles.enqueue_raffle_participation(raffle_id, user_id) do
      {:ok, _job} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Participation successfully"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: format_errors(changeset)})
    end
  end

  defp format_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
    end)
  end
end
