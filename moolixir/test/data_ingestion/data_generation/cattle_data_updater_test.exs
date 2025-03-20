defmodule CDUpTest do
  alias DataIngestion.DataGeneration.CattleDataUpdater, as: CDUp
  use ExUnit.Case
  doctest CDUp

  test "greets the world" do
    assert CDUp.hello() == :world
  end
end
