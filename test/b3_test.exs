defmodule B3Test do
  use ExUnit.Case
  doctest B3

  test "greets the world" do
    assert B3.hello() == :world
  end
end
