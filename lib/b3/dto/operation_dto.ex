defmodule B3.DTO.OperationDTO do
  @moduledoc false

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

  @spec parse_time(String.t()) :: String.t()
  defp parse_time(time), do: String.slice(time, 0, 6)

  @spec parse_date(String.t()) :: String.t()
  defp parse_date(date), do: date
end
