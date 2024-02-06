defmodule B3.DTO.OperationResponseDTO do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:ticker, :max_range_value, :max_daily_volume]

  @type t :: %{
          ticker: String.t(),
          max_range_value: float(),
          max_daily_volume: integer()
        }

  @spec new(list()) :: t()
  def new([_date, ticker, price, amount] = params) when is_list(params) do
    %{
      ticker: ticker,
      max_range_value: price / 1_000,
      max_daily_volume: amount
    }
  end

  @spec new(String.t(), float(), integer()) :: t()
  def new(ticker, max_range_value, max_daily_volume) do
    %{
      ticker: ticker,
      max_range_value: max_range_value,
      max_daily_volume: max_daily_volume
    }
  end
end
