defmodule B3.Queries.Operation do
  @moduledoc false
  alias B3.Repo
  alias B3.Models.Operation

  import Ecto.Query, warn: false

  def find_by_ticker(ticker) do
    query =
      from(o in Operation,
        where: o.ticker == ^ticker,
        group_by: [o.ticker, o.date],
        select: [o.date, o.ticker, max(o.price), sum(o.amount)]
      )

    Repo.all(query)
  end
end
