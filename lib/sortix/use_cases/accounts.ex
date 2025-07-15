defmodule Sortix.UseCases.Accounts do
  alias Sortix.Domain.Accounts.CreateUser

  def create_user(attrs) do
    with {:ok, user} <- CreateUser.call(attrs) do
      {:ok, user.id}
    end
  end
end
