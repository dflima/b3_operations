defmodule B3.Models.Operation do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required_fields ~w(ticker price amount time date)a

  schema "operations" do
    field(:ticker, :string)
    field(:price, :integer)
    field(:amount, :integer)
    field(:time, :time)
    field(:date, :date)
  end

  def changeset(operation, params \\ %{}) do
    operation
    |> cast(params, @required_fields)
  end
end
