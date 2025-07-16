import Ecto.Query
alias Oban.Job
alias Sortix.Infrastructure.Repo

all_jobs = fn ->
  Repo.all(from j in Job, where: j.queue == "draws")
end

draw_all_raffles = fn ->
  Oban.drain_queue(queue: :draws, with_safety: false, with_scheduled: true)
end

participants = fn raffle_id ->
  Sortix.Domain.Raffles.Participation
  |> where([e], e.raffle_id == ^raffle_id)
  |> Repo.all()
end
