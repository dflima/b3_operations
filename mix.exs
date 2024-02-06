defmodule B3.MixProject do
  use Mix.Project

  def project do
    [
      app: :b3_operations,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :plug_cowboy, :postgrex, :ecto],
      mod: {B3.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases() do
    [
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "run priv/repo/seeds.exs",
        "test"
      ]
    ]
  end

  defp deps do
    [
      {:csv, "~> 3.2"},
      {:ecto_sql, "~> 3.0"},
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.7"},
      {:plug, "~> 1.15"},
      {:postgrex, "~> 0.17.4"}
    ]
  end
end
