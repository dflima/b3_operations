defmodule B3.Services.Projection do
  @moduledoc """
  Service for the Operation entity.
  Provides encapsulation for the queries and aggregation.
  """

  alias B3.DTO.OperationResponseDTO
  alias B3.Repo
  alias B3.Models.Projection, as: ProjectionModel
  alias B3.Models.Operation
  alias B3.Queries.Projection, as: ProjectionQuery

  @spec aggregate(list(Operation.t()) | Operation.t()) :: any()
  def aggregate(operations) when is_list(operations) do
    operations
    |> Stream.map(&aggregate/1)
    |> Stream.run()
  end

  def aggregate(%Operation{ticker: ticker, price: price, amount: amount, date: date} = operation) do
    projection = ProjectionQuery.find_by_ticker_and_date(ticker, date)

    try do
      if is_nil(projection) do
        Repo.insert(%ProjectionModel{ticker: ticker, price: price, amount: amount, date: date})
      else
        new_amount = amount + projection.amount
        new_price = if price > projection.price, do: price, else: projection.price

        projection
        |> ProjectionModel.changeset(%{amount: new_amount, price: new_price})
        |> Repo.update()
      end
    rescue
      _ in Ecto.StaleEntryError ->
        Repo.reload(projection)
        aggregate(operation)
    end
  end

  @doc """
  Searches the database for the given ticker and optional date.

  This function raises an Enum.Empty error if either the ticker is not
  found or there are no operations for the given ticker in the given date.

  ## Examples

      iex> B3.Services.Projection.find_by_ticker_and_date("INVALID11")
      ** (Enum.EmptyError) empty error

      iex> B3.Services.Projection.find_by_ticker_and_date("SIMH3", "2024-01-27")
      ** (Enum.EmptyError) empty error

      iex> B3.Services.Projection.find_by_ticker_and_date("SIMH3")
      %{ticker: "SIMH3", max_range_value: 7.97, max_daily_volume: 900}

      iex> B3.Services.Projection.find_by_ticker_and_date("WING24")
      %{ticker: "WING24", max_range_value: 129340.0, max_daily_volume: 12}

      iex> B3.Services.Projection.find_by_ticker_and_date("WING24", "2024-01-27")
      %{ticker: "WING24", max_range_value: 129340.0, max_daily_volume: 3}

  """
  @spec find_by_ticker_and_date(String.t(), Date.t() | nil) :: OperationResponseDTO.t()
  def find_by_ticker_and_date(ticker, date \\ nil)

  def find_by_ticker_and_date(ticker, date) when is_nil(date) do
    ticker
    |> ProjectionQuery.find_by_ticker()
    |> parse_operations(ticker)
  end

  def find_by_ticker_and_date(ticker, date) do
    ticker
    |> ProjectionQuery.find_by_ticker_since_date(date)
    |> parse_operations(ticker)
  end

  @spec parse_operations(list(Operation.t()), String.t()) :: OperationResponseDTO.t()
  defp parse_operations(operation_list, ticker) do
    operations = Enum.map(operation_list, &OperationResponseDTO.new/1)

    max_range_value =
      operations
      |> Enum.max_by(& &1.max_range_value)
      |> Map.get(:max_range_value)

    max_daily_volume =
      operations
      |> Enum.max_by(& &1.max_daily_volume)
      |> Map.get(:max_daily_volume)

    OperationResponseDTO.new(ticker, max_range_value, max_daily_volume)
  end
end
