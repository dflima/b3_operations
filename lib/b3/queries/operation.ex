defmodule B3.Queries.Operation do
  @moduledoc false

  alias B3.Repo
  alias B3.Models.Operation

  import Ecto.Query, warn: false

  @spec find_by_ticker_and_date(String.t(), String.t()) :: list(Operation.t())
  def find_by_ticker_and_date(ticker, date) do
    from(o in Operation)
    |> where([o], o.ticker == ^ticker)
    |> where([o], o.date >= ^date)
    |> group_by([o], [o.ticker, o.date])
    |> select([o], [o.date, o.ticker, max(o.price), sum(o.amount)])
    |> Repo.all()
  end

  @spec find_by_ticker(String.t()) :: list(Operation.t())
  def find_by_ticker(ticker) do
    from(o in Operation)
    |> where([o], o.ticker == ^ticker)
    |> group_by([o], [o.ticker, o.date])
    |> select([o], [o.date, o.ticker, max(o.price), sum(o.amount)])
    |> Repo.all()
  end
end
