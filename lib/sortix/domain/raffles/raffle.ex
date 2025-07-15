defmodule Sortix.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @statuses ~w(open closed drawn)

  schema "raffles" do
    field :name, :string
    field :draw_date, :utc_datetime_usec
    field :status, :string, default: "open"

    timestamps()
  end

  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, [:name, :draw_date, :status])
    |> validate_required([:name, :draw_date])
    |> validate_inclusion(:status, @statuses)
  end
end
