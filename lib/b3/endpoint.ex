defmodule B3.Endpoint do
  @moduledoc false

  use Plug.{Router, Debugger, ErrorHandler}

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  get "/operations" do
    with %{query_params: %{"ticker" => ticker}} <- fetch_query_params(conn) do
      response = B3.Queries.Operation.find_by_ticker(ticker) |> Enum.map(fn [date, ticker, price, amount] ->
        %{date: date, ticker: ticker, price: price, amount: amount}
      end)

      send_resp(conn, 200, Jason.encode!(response))
    else
      _ -> send_resp(conn, 400, "bad request")
    end

    # {
    #   ticker: "PETR4",
    #   max_range_value: 0,
    #   max_daily_volume: 0
    # }
  end

  match _ do
    send_resp(conn, 404, "Route not found.")
  end
end
