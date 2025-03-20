defmodule CDGenTest do
  alias DataIngestion.DataGeneration.CattleDataGenerator, as: CDGen
  use ExUnit.Case
  doctest CDGen

  test "greets the world" do
    assert CDGen.hello() == :world
  end
end
