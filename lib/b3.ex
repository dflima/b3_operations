defmodule B3 do
  @moduledoc """
  Documentation for `B3`.
  """
  alias B3.DTO.OperationDTO

  @doc """
  This function is used to transform the file from B3 into a more
  clean and known format: "ticker;date;time;price;amount".

  ## Examples

      iex> B3.transform_operations("/tmp/25-01-2024_NEGOCIOSAVISTA.txt")
      :ok
  """
  @spec transform_operations(Path.t()) :: any()
  def transform_operations(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(&OperationDTO.from_stream/1)
    |> CSV.encode(separator: ?;, headers: true)
    |> Stream.into(File.stream!(file_path <> ".operations.csv", [:write, :utf8]))
    |> Stream.run()
  end

  @doc """
  This function uses data from the files created by transform_operations/1
  and inserts into the database.

  ## Examples

      iex> B3.transform_operations("/tmp/25-01-2024_NEGOCIOSAVISTA.txt.operations.csv")
      :ok
  """
  @spec import_operations(Path.t()) :: any()
  def import_operations(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(fn {:ok, operation} ->
      %B3.Models.Operation{}
      |> B3.Models.Operation.changeset(operation)
      |> B3.Repo.insert()
    end)
    |> Stream.run()
  end

  @doc """
  CLI entrypoint for searching operations.

  ## Examples

      iex> B3.find_by_ticker_and_date("INVALID11")
      No records found for INVALID11 and . Error: %Enum.EmptyError{message: "empty error"}

      iex> B3.find_by_ticker_and_date("SIMH3", "2024-03-29")
      No records found for INVALID11 and 2024-03-29. Error: %Enum.EmptyError{message: "empty error"}

      iex> B3.find_by_ticker_and_date("WING24", "2024-01-27")
      %{ticker: "WING24", max_range_value: 129340.0, max_daily_volume: 3}

  """
  @spec find_by_ticker_and_date(any(), any()) :: :ok | B3.OperationResponseDTO.t()
  def find_by_ticker_and_date(ticker, date \\ nil) do
    try do
      B3.Services.Operation.find_by_ticker_and_date(ticker, date)
    rescue
      e in Enum.EmptyError ->
        IO.puts("No records found for #{ticker} and #{date}. Error: #{inspect(e)}")
    end
  end
end
