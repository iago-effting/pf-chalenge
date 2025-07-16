defmodule Sortix.Domain.Raffles.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "raffle_entries" do
    field :raffle_id, :binary_id
    field :user_id, :binary_id
  end

  def register(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:raffle_id, :user_id])
    |> validate_required([:raffle_id, :user_id])
    |> unique_constraint([:raffle_id, :user_id])
  end
end
