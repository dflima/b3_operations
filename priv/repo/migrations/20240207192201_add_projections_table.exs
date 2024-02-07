defmodule B3.Repo.Migrations.AddProjectionsTable do
  use Ecto.Migration

  def change do
    create table(:projections) do
      add :ticker, :string
      add :version, :integer, default: 1
      add :price, :integer
      add :amount, :integer
      add :date, :date
    end

    create index(:projections, [:ticker])
    create index(:projections, [:ticker, :date])
  end
end
