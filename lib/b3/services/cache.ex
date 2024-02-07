defmodule B3.Services.Cache do
  alias B3.Cache.Operation

  def get(ticker) do
    ticker
    |> Operation.get()
    |> parse_operations(ticker)
  end

  defp parse_operations(nil, _ticker), do: nil

  defp parse_operations(operations, ticker) do
    operations
    |> Enum.group_by(& &1.date)
    |> Enum.to_list()
    |> Enum.map(fn {_date, list} -> aggregate_operations(list, ticker) end)
  end

  defp aggregate_operations(operations, ticker) do
    initial_value = %B3.Models.Operation{ticker: ticker, price: 0, amount: 0}

    Enum.reduce(operations, initial_value, fn operation, acc ->
      amount = Map.get(acc, :amount)
      price = Map.get(acc, :price)

      %B3.Models.Operation{
        acc
        | amount: amount + operation.amount,
          price: if(operation.price > price, do: operation.price, else: price)
      }
    end)
  end
end
