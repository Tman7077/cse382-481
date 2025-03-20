defmodule DataGenTest do
  alias DataIngestion.DataGeneration, as: DataGen
  use ExUnit.Case
  doctest DataGen

  test "greets the world" do
    assert DataGen.hello() == :world
  end
end
