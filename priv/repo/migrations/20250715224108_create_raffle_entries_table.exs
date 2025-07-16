defmodule Sortix.Infrastructure.Repo.Migrations.CreateRaffleEntriesTable do
  use Ecto.Migration

  def change do
    create table(:raffle_entries, primary_key: false) do
      add :raffle_id, references(:raffles, type: :uuid), null: false
      add :user_id, references(:users, type: :uuid), null: false
    end

    create unique_index(:raffle_entries, [:raffle_id, :user_id])
  end
end
