defmodule DataStorageTest do
  use ExUnit.Case
  doctest DataStorage

  test "greets the world" do
    assert DataStorage.hello() == :world
  end
end
