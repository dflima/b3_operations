defmodule OperationServiceTest do
  use B3.RepoCase

  alias Enum.EmptyError
  alias B3.Services.Operation

  doctest(B3.Services.Operation)

  test "raises EmptyError for invalid ticker" do
    assert_raise EmptyError, fn ->
      Operation.find_by_ticker_and_date("INVALID11")
    end
  end

  test "raises EmptyError when there's no operation for given ticker" do
    assert_raise EmptyError, fn ->
      Operation.find_by_ticker_and_date("SIMH3", "2024-01-27")
    end
  end

  test "returns OperationResponseDTO for 1 operation with ticker SIMH3" do
    expected = %{
      ticker: "SIMH3",
      max_range_value: 7.97,
      max_daily_volume: 900
    }

    ^expected = Operation.find_by_ticker_and_date("SIMH3")
  end

  test "returns OperationResponseDTO for all operations with ticker WING24" do
    expected = %{ticker: "WING24", max_range_value: 129_340.0, max_daily_volume: 12}

    ^expected = Operation.find_by_ticker_and_date("WING24")
  end

  test "returns OperationResponseDTO for all operations with ticker WING24 starting on 2024-01-27" do
    expected = %{ticker: "WING24", max_range_value: 129_340.0, max_daily_volume: 3}

    ^expected = Operation.find_by_ticker_and_date("WING24", "2024-01-27")
  end
end
