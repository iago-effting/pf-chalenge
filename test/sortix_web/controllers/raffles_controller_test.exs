defmodule SortixWeb.RafflesControllerTest do
  use SortixWeb.ConnCase, async: true

  alias Sortix.Infrastructure.Repo
  alias Sortix.Raffles.Raffle

  describe "POST /raffles" do
    test "creates a raffle with valid parameters", %{conn: conn} do
      params = %{"name" => "Test Raffle", "draw_date" => "2023-10-01T12:00:00Z"}

      assert %{"id" => id} =
               conn
               |> post(~p"/api/raffles", params)
               |> json_response(200)

      assert_enqueued(
        worker: Sortix.Infrastructure.Jobs.RaffleDrawJob,
        args: %{"raffle_id" => id},
        scheduled_at: brazil_naive_to_utc(~N[2023-10-01 12:00:00])
      )
    end

    test "returns error for invalid date format", %{conn: conn} do
      params = %{"name" => "Test Raffle", "draw_date" => "invalid-date"}

      response =
        conn
        |> post(~p"/api/raffles", params)
        |> json_response(400)

      assert response["error"] == "Invalid input"
      refute_enqueued(worker: Sortix.Infrastructure.Jobs.Raffles.DrawRaffleJob)
    end
  end

  describe "GET /raffles/:id" do
    test "returns 200 with raffle and winner data when drawn", %{conn: conn} do
      {:ok, raffle} = raffle_fixure()
      {:ok, user} = user_fixure()

      raffle =
        raffle
        |> Raffle.put_winner(user.id)
        |> Repo.update!()
        |> Repo.preload(:winner_user)

      conn =
        get(conn, ~p"/api/raffles/#{raffle.id}")

      assert json_response(conn, 200) == %{
               "id" => user.id,
               "name" => user.name,
               "email" => user.email
             }
    end
  end
end
