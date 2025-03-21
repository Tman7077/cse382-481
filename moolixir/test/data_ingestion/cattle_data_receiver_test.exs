defmodule CDRecvTest do
  alias DataIngestion.CattleDataReceiver, as: CDRecv
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "start/0" do
    test "spawns and registers the receiver process" do
      # Start the receiver process.
      CDRecv.start()

      # Verify that the process is registered.
      pid = Process.whereis(:remote_receiver)
      assert is_pid(pid)

      # Clean up by terminating the process.
      Process.exit(pid, :kill)
    end
  end

  describe "loop/0" do
    test "prints received data when a message is sent" do
      test_data = %{test_key: "test_value", number: 42}

      captured =
        capture_io(fn ->
          # Spawn the loop in a separate process.
          pid = spawn(fn -> CDRecv.loop() end)
          # Send a message to trigger the printing.
          send(pid, {:data, test_data})
          # Give it a moment to process the message.
          Process.sleep(100)
          # Terminate the spawned process.
          Process.exit(pid, :kill)
        end)

      # Verify that the output includes the printed header and parts of the map.
      assert captured =~ "Generated data:"
      assert captured =~ "test_key"
      assert captured =~ "test_value"
      assert captured =~ "number"
      assert captured =~ "42"
    end
  end
end
