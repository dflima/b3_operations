import Config

config :b3_operations,
  ecto_repos: [B3.Repo]

config :b3_operations,
  port: 8001

import_config "#{config_env()}.exs"
