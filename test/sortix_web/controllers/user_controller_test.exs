defmodule SortixWeb.UserControllerTest do
  use SortixWeb.ConnCase, async: true

  describe "POST /users" do
    test "creates a user with valid parameters", %{conn: conn} do
      params = %{"name" => "Jane Doe", "email" => "jane@example.com"}

      assert %{"id" => id} =
               conn
               |> post(~p"/api/users", params)
               |> json_response(200)

      assert is_binary(id)
    end

    test "fails with invalid email", %{conn: conn} do
      params = %{"name" => "Bad Email", "email" => "invalid"}

      conn = post(conn, ~p"/api/users", params)

      assert %{"errors" => errors} = json_response(conn, 422)
      assert "has invalid format" in errors["email"]
    end
  end
end
