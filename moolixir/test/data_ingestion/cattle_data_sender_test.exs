defmodule CDSendTest do
  alias DataIngestion.CattleDataSender, as: CDSend
  use ExUnit.Case
  doctest CDSend

  test "greets the world" do
    assert CDSend.hello() == :world
  end
end
