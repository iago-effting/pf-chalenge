defmodule SortixWeb.WinnerJSON do
  def winner(nil), do: nil

  def winner(%{winner: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
