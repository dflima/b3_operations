defmodule B3.DTO.OperationResponseDTOTest do
  alias B3.DTO.OperationResponseDTO
  use ExUnit.Case

  test "new/1 returns a OperationResponseDTO" do
    expected = %{
      ticker: "WING24",
      max_range_value: 10.0,
      max_daily_volume: 5
    }

    ^expected = OperationResponseDTO.new(["2024-01-25", "WING24", 10000, 5])
  end

  test "new/3 returns a OperationResponseDTO" do
    expected = %{
      ticker: "WING24",
      max_range_value: 10.0,
      max_daily_volume: 5
    }

    ^expected = OperationResponseDTO.new("WING24", 10.0, 5)
  end
end
