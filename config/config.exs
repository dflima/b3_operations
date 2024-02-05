import Config

config :b3_operations, B3.Repo,
  database: "b3_operations_repo",
  username: "user",
  password: "pass",
  hostname: "db"

config :b3_operations,
  ecto_repos: [B3.Repo]

config :b3_operations,
  port: 8001
