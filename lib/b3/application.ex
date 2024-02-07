defmodule B3.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      B3.Repo,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: B3.Endpoint,
        options: [port: Application.get_env(:b3_operations, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: B3.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
