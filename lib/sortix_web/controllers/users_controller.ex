defmodule SortixWeb.UserController do
  use SortixWeb, :controller

  alias Sortix.UseCases.Accounts

  def create(conn, params) do
    case Accounts.create_user(params) do
      {:ok, id} ->
        json(conn, %{id: id})

      {:error, %Ecto.Changeset{} = cs} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(cs)})
    end
  end

  defp translate_errors(cs) do
    Ecto.Changeset.traverse_errors(cs, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {k, v}, acc -> String.replace(acc, "%{#{k}}", to_string(v)) end)
    end)
  end
end
