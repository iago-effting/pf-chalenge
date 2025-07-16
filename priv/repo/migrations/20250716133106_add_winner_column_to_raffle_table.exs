defmodule Sortix.Infrastructure.Repo.Migrations.AddWinnerColumnToRaffleTable do
  use Ecto.Migration

  def change do
    alter table(:raffles) do
      add :winner_user_id, references(:users, type: :binary_id, on_delete: :nilify_all)
    end
  end
end
