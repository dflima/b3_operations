defmodule B3.Repo do
  use Ecto.Repo,
    otp_app: :b3_operations,
    adapter: Ecto.Adapters.Postgres
end
