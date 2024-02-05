defmodule B3.Repo.Migrations.AddOperationsTable do
  use Ecto.Migration

  def change do
    create table(:operations) do
      add :ticker, :string  # CodigoInstrumento
      add :price, :integer  # PrecoNegocio
      add :amount, :integer # QuantidadeNegociada
      add :time, :time      # HoraFechamento
      add :date, :date      # DataNegocio
    end

    create index(:operations, [:ticker])
    create index(:operations, [:ticker, :date])
  end
end
