defmodule Sortix.Repo.Migrations.CreateRafflesTable do
  use Ecto.Migration

  def up do
    execute("CREATE TYPE raffle_status AS ENUM ('open', 'closed', 'drawn')")

    create table(:raffles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :draw_date, :utc_datetime_usec, null: false
      add :status, :raffle_status, default: "open", null: false

      timestamps()
    end
  end

  def down do
    drop table(:raffles)
    execute("DROP TYPE raffle_status")
  end
end
