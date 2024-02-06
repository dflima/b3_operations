defmodule B3.DTO.OperationDTO do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:ticker, :date, :time, :price, :amount]

  @type t :: %{
          ticker: String.t(),
          date: String.t(),
          time: String.t(),
          price: String.t(),
          amount: String.t()
        }

  @spec from_stream({:ok, map()}) :: t()
  def from_stream({:ok, map}), do: new(map)

  @spec new(map()) :: t()
  def new(%{
        "CodigoInstrumento" => ticker,
        "DataNegocio" => date,
        "HoraFechamento" => time,
        "PrecoNegocio" => price,
        "QuantidadeNegociada" => amount
      }) do
    %{
      ticker: ticker,
      date: date,
      time: parse_time(time),
      price: parse_price(price),
      amount: amount
    }
  end

  @spec parse_time(String.t()) :: String.t()
  defp parse_time(time), do: String.slice(time, 0, 6)

  @spec parse_time(String.t()) :: String.t()
  defp parse_price(price), do: String.replace(price, ",", "")
end
