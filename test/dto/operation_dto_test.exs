defmodule B3.DTO.OperationDTOTest do
  alias B3.DTO.OperationDTO
  use ExUnit.Case

  test "from_stream/1 returns a new OperationDTO" do
    map = %{
      "CodigoInstrumento" => "WING24",
      "DataNegocio" => "2024-01-25",
      "HoraFechamento" => "030350417",
      "PrecoNegocio" => "10,000",
      "QuantidadeNegociada" => 5
    }

    expected = %{
      ticker: "WING24",
      date: "2024-01-25",
      time: "030350",
      price: "10000",
      amount: 5
    }

    ^expected = OperationDTO.from_stream({:ok, map})
  end
end
