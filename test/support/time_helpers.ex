defmodule Sortix.TimeHelpers do
  @brazil_tz "America/Sao_Paulo"
  @utc_tz "Etc/UTC"

  def brazil_naive_to_utc(naive_dt) do
    naive_dt
    |> DateTime.from_naive!(@brazil_tz)
    |> DateTime.shift_zone!(@utc_tz)
  end

  def utc_to_brazil(dt), do: DateTime.shift_zone!(dt, @brazil_tz)
end
