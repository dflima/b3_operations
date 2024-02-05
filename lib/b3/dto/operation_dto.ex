defmodule B3.DTO.OperationDTO do
  @moduledoc false

  alias B3.Models.Operation

  @time_regex ~r"(?<hour>\d{2})(?<minute>\d{2})(?<second>\d{2})(?<milisecond>\d{3})"

  @spec to_model(map()) :: %Operation{} | nil
  def to_model(%{
        "AcaoAtualizacao" => _,
        "CodigoIdentificadorNegocio" => _,
        "CodigoInstrumento" => ticker,
        "CodigoParticipanteComprador" => _,
        "CodigoParticipanteVendedor" => _,
        "DataNegocio" => date,
        "DataReferencia" => _,
        "HoraFechamento" => time,
        "PrecoNegocio" => price,
        "QuantidadeNegociada" => amount,
        "TipoSessaoPregao" => _
      }) do
    %Operation{
      ticker: ticker,
      date: parse_date(date),
      time: parse_time(time),
      price: String.replace(price, ",", ""),
      amount: amount
    }
  end

  @spec to_struct(map()) :: map()
  def to_struct(%{
        "AcaoAtualizacao" => _,
        "CodigoIdentificadorNegocio" => _,
        "CodigoInstrumento" => ticker,
        "CodigoParticipanteComprador" => _,
        "CodigoParticipanteVendedor" => _,
        "DataNegocio" => date,
        "DataReferencia" => _,
        "HoraFechamento" => time,
        "PrecoNegocio" => price,
        "QuantidadeNegociada" => amount,
        "TipoSessaoPregao" => _
      }) do
    %{
      ticker: ticker,
      date: parse_date(date),
      time: parse_time(time),
      price: String.replace(price, ",", ""),
      amount: amount
    }
  end

  @spec parse_time(String.t()) :: Time.t()
  defp parse_time(time) do
    [hour: h, milisecond: _, minute: m, second: s] =
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
end
