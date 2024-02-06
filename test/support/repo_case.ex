defmodule B3.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias B3.Repo

      import Ecto
      import Ecto.Query
      import B3.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(B3.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(B3.Repo, {:shared, self()})
    end

    :ok
  end
end
