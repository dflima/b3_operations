defmodule B3.Services.Operation do
  @moduledoc false

  alias B3.DTO.OperationResponseDTO
  alias B3.Queries.Operation, as: OperationQuery

  @spec find_by_ticker_and_date(String.t(), Date.t() | nil) :: OperationResponseDTO.t()
  def find_by_ticker_and_date(ticker, date \\ nil)

  def find_by_ticker_and_date(ticker, date) when is_nil(date) do
    ticker
    |> OperationQuery.find_by_ticker()
    |> parse_operations(ticker)
  end

  def find_by_ticker_and_date(ticker, date) do
    ticker
    |> OperationQuery.find_by_ticker_and_date(date)
    |> parse_operations(ticker)
  end

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
