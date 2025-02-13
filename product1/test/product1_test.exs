defmodule Product1Test do
  use ExUnit.Case
  doctest Product1

  test "greets the world" do
    assert Product1.hello() == :world
  end
end
