defmodule DataGenTest do
  alias DataIngestion.DataGeneration, as: DataGen
  use ExUnit.Case
  doctest DataGen

  test "module DataIngestion.DataGeneration is a facade. No unit tests needed." do
    assert 0 == 0
  end
end
