defmodule MoolixirTest do
  use ExUnit.Case
  doctest Moolixir

  test "greets the world" do
    assert Moolixir.hello() == :world
  end
end
