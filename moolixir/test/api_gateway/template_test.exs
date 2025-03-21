defmodule APIGatewayTest do
  use ExUnit.Case
  doctest APIGateway

  test "greets the world" do
    assert APIGateway.hello() == :world
  end
end
