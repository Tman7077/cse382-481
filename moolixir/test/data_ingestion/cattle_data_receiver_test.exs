defmodule CDRecvTest do
  alias DataIngestion.CattleDataReceiver, as: CDRecv
  use ExUnit.Case
  doctest CDRecv

  test "greets the world" do
    assert CDRecv.hello() == :world
  end
end
