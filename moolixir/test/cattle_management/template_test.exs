defmodule CattleManagementTest do
  use ExUnit.Case
  doctest CattleManagement

  test "greets the world" do
    assert CattleManagement.hello() == :world
  end
end
