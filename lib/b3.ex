defmodule B3 do
  @moduledoc """
  Documentation for `B3`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> B3.hello()
      :world

  """
  def hello do
    :world
  end

  @spec import_operations(Path.t()) :: any()
  def import_operations(file_path) do
    File.stream!(file_path)
    |> CSV.decode(separator: ?;, headers: true)
    |> Stream.map(fn {:ok, param} -> B3.DTO.OperationDTO.to_model(param) end)
    |> Stream.map(fn %B3.Models.Operation{} = operation ->
      %B3.Models.Operation{}
      |> B3.Models.Operation.changeset(Map.from_struct(operation))
      |> B3.Repo.insert()
     end)
    |> Stream.run()
  end
end
