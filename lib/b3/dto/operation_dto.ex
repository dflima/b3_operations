defmodule B3.DTO.OperationDTO do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:ticker, :date, :time, :price, :amount]

  @time_regex ~r"(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})"

  @type t :: %{
          ticker: String.t(),
          date: String.t(),
          time: String.t(),
          price: String.t(),
          amount: String.t()
        }

  @type model :: %{
          ticker: String.t(),
          date: Date.t(),
          time: Time.t(),
          price: Integer.t(),
          amount: Integer.t()
        }

  @spec from_external_file({:ok, map()}) :: t()
  def from_external_file(
        {:ok,
         %{
           "CodigoInstrumento" => ticker,
           "DataNegocio" => date,
           "HoraFechamento" => time,
           "PrecoNegocio" => price,
           "QuantidadeNegociada" => amount
         }}
      ),
      do: %{
        ticker: ticker,
        date: date,
        time: String.slice(time, 0, 6),
        price: parse_price(price),
        amount: amount
      }

  @spec to_model({:ok, map()}) :: model()
  def to_model(
        {:ok,
         %{
           "ticker" => ticker,
           "date" => date,
           "time" => time,
           "price" => price,
           "amount" => amount
         }}
      ),
      do: %{
        ticker: ticker,
        date: parse_date(date),
        time: parse_time(time),
        price: parse_price(price) |> String.to_integer(),
        amount: String.to_integer(amount)
      }

  @spec parse_time(String.t()) :: Time.t()
  defp parse_time(time) do
    [hour: h, minute: m, second: s] =
      @time_regex
      |> Regex.named_captures(time)
      |> Enum.map(fn {name, value} -> {String.to_atom(name), String.to_integer(value)} end)

    Time.new!(h, m, s)
  end

  @spec parse_date(String.t()) :: Date.t()
  defp parse_date(date) do
    [year, month, day] = String.split(date, "-")
    Date.new!(String.to_integer(year), String.to_integer(month), String.to_integer(day))
  end

  @spec parse_price(String.t()) :: String.t()
  defp parse_price(price), do: price |> String.replace(",", "")
end
