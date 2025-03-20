defmodule CDStreamTest do
  alias DataIngestion.CattleDataStream, as: CDStream
  use ExUnit.Case
  doctest CDStream

  test "greets the world" do
    assert CDStream.hello() == :world
  end
end
