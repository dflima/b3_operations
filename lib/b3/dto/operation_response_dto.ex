defmodule B3.DTO.OperationResponseDTO do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:date, :ticker, :max_range_value, :max_daily_volume]

  @type t :: %{
          date: Date.t(),
          ticker: String.t(),
          max_range_value: float(),
          max_daily_volume: integer()
        }

  @spec new(list()) :: B3.DTO.OperationResponseDTO.t()
  def new([date, ticker, price, amount]) do
    %{
      date: date,
      ticker: ticker,
      max_range_value: price / 1_000,
      max_daily_volume: amount
    }
  end
end
