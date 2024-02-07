defmodule B3.Cache.Operation do
  alias B3.Models.Operation
  use GenServer

  def start_link(name \\ __MODULE__) do
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def put_list(pid \\ __MODULE__, operation_list) do
    operation_list
    |> Stream.map(fn %Operation{} = operation -> put(pid, operation) end)
    |> Stream.run()
  end

  def put(pid \\ __MODULE__, %Operation{} = operation) do
    GenServer.cast(pid, {:put, operation})
  end

  def get(pid \\ __MODULE__, ticker) do
    GenServer.call(pid, {:get, ticker})
  end

  @impl true
  def init(initial_state), do: {:ok, initial_state}

  @impl true
  def handle_cast({:put, %Operation{ticker: ticker} = operation}, state) do
    key = String.to_atom(ticker)
    new_state = Map.put(state, key, [operation | Map.get(state, key, [])])

    {:noreply, new_state}
  end

  @impl true
  def handle_call({:get, ticker}, _from, state) do
    {:reply, Map.get(state, String.to_atom(ticker)), state}
  end
end

%{
  ticker: "WING24",
  price: 128_445_000,
  amount: 5,
  time: ~T[10:41:09],
  date: ~D[2024-02-01]
}
