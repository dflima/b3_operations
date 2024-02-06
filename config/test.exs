import Config

config :b3_operations, B3.Repo,
  database: "b3_operations_repo_test",
  username: "user",
  password: "pass",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
