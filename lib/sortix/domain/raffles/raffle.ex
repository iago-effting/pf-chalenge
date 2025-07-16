defmodule Sortix.Raffles.Raffle do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "raffles" do
    field :name, :string
    field :draw_date, :utc_datetime_usec
    field :status, Ecto.Enum, values: [:open, :closed, :drawn], default: :open

    belongs_to :winner_user, Sortix.Domain.Accounts.User, type: :binary_id

    timestamps()
  end

  def changeset(raffle, attrs) do
    raffle
    |> cast(attrs, [:name, :draw_date, :status])
    |> validate_required([:name, :draw_date])
  end

  def put_winner(%__MODULE__{} = raffle, user_id) when is_binary(user_id) do
    change(raffle, status: :drawn, winner_user_id: user_id)
  end
end
