defmodule B3.Endpoint do
  @moduledoc false
  alias Enum.EmptyError

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
    with %{query_params: %{"ticker" => ticker} = params} <- fetch_query_params(conn) do
      date = Map.get(params, "DataNegocio")

      try do
        response = B3.Services.Operation.find_by_ticker_and_date(ticker, date)
        send_resp(conn, 200, Jason.encode!(response))
      rescue
        _ in EmptyError -> send_resp(conn, 404, Jason.encode!(%{error: "Not found."}))
      end
    else
      _ -> send_resp(conn, 400, "bad request")
    end
  end

  match _ do
    send_resp(conn, 404, "Route not found.")
  end
end
