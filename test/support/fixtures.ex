defmodule Sortix.Test.Fixtures do
  alias Sortix.Domain.Accounts.CreateUser
  alias Sortix.Domain.Service.CreateRaffle

  @raffle_attrs %{
    name: "Test Raffle",
    draw_date: ~U[2025-12-31 23:59:59Z]
  }

  def user_fixure(attrs \\ %{}) do
    %{
      name: "Test User",
      email: "user_#{System.unique_integer()}@example.com"
    }
    |> Map.merge(attrs)
    |> CreateUser.call()
  end

  def raffle_fixure(attrs \\ %{}) do
    @raffle_attrs
    |> Map.merge(attrs)
    |> CreateRaffle.call()
  end
end
