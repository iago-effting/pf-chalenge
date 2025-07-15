defmodule Sortix.Repo do
  use Ecto.Repo,
    otp_app: :sortix,
    adapter: Ecto.Adapters.Postgres
end
