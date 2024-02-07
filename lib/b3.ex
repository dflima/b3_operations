defmodule B3 do
  @moduledoc """
  Documentation for `B3`.
  """
  alias B3.Cache
  alias B3.Models.Operation
  alias B3.Repo
  alias B3.DTO.OperationDTO

  @doc """
  This function is used to normalize the file from B3 into
  the following format: "ticker;date;time;price;amount".

  ## Examples

      iex> B3.normalize_file("/tmp/25-01-2024_NEGOCIOSAVISTA.txt")
      :ok
  """
  @spec normalize_file(Path.t()) :: any()
  def normalize_file(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(&OperationDTO.from_external_file/1)
    |> CSV.encode(separator: ?;, headers: true)
    |> Stream.into(File.stream!(file_path <> ".operations.csv", [:write, :utf8]))
    |> Stream.run()
  end

  @doc """
  This function uses data from the files created by normalize_file/1
  and inserts into the database.

  ## Examples

      iex> B3.import_operations("/tmp/25-01-2024_NEGOCIOSAVISTA.txt.operations.csv")
      :ok
  """
  @spec import_operations(Path.t()) :: any()
  def import_operations(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(&OperationDTO.to_model/1)
    |> Stream.chunk_every(10_000)
    |> Stream.map(&Repo.insert_all(Operation, &1, returning: true))
    |> Stream.map(fn {_, list} -> Cache.Operation.put_list(list) end)
    |> Stream.run()
  end

  def import_operations do
    file_paths = Path.wildcard "./priv/b3/*.csv"
    Enum.map(file_paths, &import_operations/1)
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
