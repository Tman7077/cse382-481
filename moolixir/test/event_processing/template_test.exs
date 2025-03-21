defmodule EventProcessingTest do
  use ExUnit.Case
  doctest EventProcessing

  test "greets the world" do
    assert EventProcessing.hello() == :world
  end
end
