defmodule B3 do
  @moduledoc """
  Documentation for `B3`.
  """
  alias B3.DTO.OperationDTO

  @doc """
  Hello world.

  ## Examples

      iex> B3.hello()
      :world

  """
  def hello do
    :world
  end

  @spec transform_operations(Path.t()) :: any()
  def transform_operations(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(&OperationDTO.from_stream/1)
    |> CSV.encode(separator: ?;, headers: true)
    |> Stream.into(File.stream!(file_path <> ".operations.csv", [:write, :utf8]))
    |> Stream.run()
  end

  @spec find_by_ticker_and_date(any(), any()) :: :ok | B3.OperationResponseDTO.t()
  def find_by_ticker_and_date(ticker, date) do
    try do
      B3.Services.Operation.find_by_ticker_and_date(ticker, date)
    rescue
      e in EmptyError ->
        IO.puts("No records found for #{ticker} and #{date}. Error: #{inspect(e)}")
    end
  end
end
