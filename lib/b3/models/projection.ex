defmodule B3.Models.Projection do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required_fields ~w(ticker price amount date)a

  schema "projections" do
    field(:ticker, :string)
    field(:price, :integer)
    field(:amount, :integer)
    field(:date, :date)
    field(:version, :integer, default: 1)
  end

  def changeset(projection, params \\ %{}) do
    projection
    |> cast(params, @required_fields)
    |> optimistic_lock(:version)
  end
end
