defmodule SortixWeb.RafflesControllerTest do
  use SortixWeb.ConnCase, async: true

  describe "POST /raffles" do
    test "creates a raffle with valid parameters", %{conn: conn} do
      params = %{"name" => "Test Raffle", "draw_date" => "2023-10-01T12:00:00Z"}

      assert %{"id" => id} =
               conn
               |> post(~p"/api/raffles", params)
               |> json_response(200)

      assert_enqueued(
        worker: Sortix.Infrastructure.Jobs.Raffles.DrawRaffleJob,
        args: %{"raffle_id" => id},
        scheduled_at: ~U[2023-10-01 12:00:00Z]
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
end
