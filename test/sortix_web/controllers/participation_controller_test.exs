defmodule SortixWeb.ParticipationControllerTest do
  use SortixWeb.ConnCase, async: true

  setup do
    {:ok, raffle} = raffle_fixure()
    {:ok, user} = user_fixure()

    {:ok, raffle: raffle, user: user}
  end

  describe "POST /raffles/:raffle_id/participations" do
    test "creates an entry successfully", %{conn: conn, raffle: raffle, user: user} do
      params = %{"user_id" => user.id}

      conn
      |> post(~p"/api/raffles/#{raffle.id}/participations", params)
      |> json_response(200)

      assert_enqueued(
        worker: Sortix.Infrastructure.Jobs.RaffleParticipationJob,
        args: %{"raffle_id" => raffle.id, "user_id" => user.id}
      )
    end

    test "is idempotent on duplicate entry", %{conn: conn, raffle: raffle, user: user} do
      post(conn, ~p"/api/raffles/#{raffle.id}/participations", %{"user_id" => user.id})
      conn = post(conn, ~p"/api/raffles/#{raffle.id}/participations", %{"user_id" => user.id})

      assert response(conn, 200) == "{\"message\":\"Participation successfully\"}"

      assert_enqueued(
        worker: Sortix.Infrastructure.Jobs.RaffleParticipationJob,
        args: %{"raffle_id" => raffle.id, "user_id" => user.id}
      )
    end
  end
end
