defmodule B3.Queries.Projection do
  @moduledoc false

  alias B3.Repo
  alias B3.Models.Projection

  import Ecto.Query, warn: false

  @spec find_by_ticker_and_date(String.t(), String.t()) :: Projection.t()
  def find_by_ticker_and_date(ticker, date) do
    from(p in Projection)
    |> where([p], p.ticker == ^ticker)
    |> where([p], p.date == ^date)
    |> Repo.one()
  end

  @spec find_by_ticker_since_date(String.t(), String.t()) :: list(Projection.t())
  def find_by_ticker_since_date(ticker, date) do
    from(p in Projection)
    |> where([p], p.ticker == ^ticker)
    |> where([p], p.date >= ^date)
    |> group_by([p], [p.ticker, p.date])
    |> select([p], [p.date, p.ticker, max(p.price), sum(p.amount)])
    |> Repo.all()
  end

  @spec find_by_ticker(String.t()) :: list(Projection.t())
  def find_by_ticker(ticker) do
    from(p in Projection)
    |> where([p], p.ticker == ^ticker)
    |> group_by([p], [p.ticker, p.date])
    |> select([p], [p.date, p.ticker, max(p.price), sum(p.amount)])
    |> Repo.all()
  end
end
