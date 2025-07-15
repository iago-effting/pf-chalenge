defmodule Sortix.Domain.Accounts.CreateUser do
  alias Sortix.Domain.Accounts.User
  alias Sortix.Infrastructure.Repo

  def call(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
