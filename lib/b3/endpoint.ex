defmodule B3.Endpoint do
  use Plug.{Router, Debugger, ErrorHandler}

  require Logger

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason)
  plug(:dispatch)

  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  match _ do
    send_resp(conn, 404, "Route not found.")
  end
end
