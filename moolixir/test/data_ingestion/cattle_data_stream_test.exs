defmodule CDStreamTest do
  alias DataIngestion.CattleDataStream, as: CDStream
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO

  @test_where node()

  setup do
    # Start the stream (which also starts the sender)
    {:ok, stream_pid} = CDStream.start_link(@test_where)
    # Register self() as the remote receiver so that messages sent by the sender are delivered here.
    Process.register(self(), :remote_receiver)

    on_exit(fn ->
      # Only unregister if :remote_receiver is still registered to a PID.
      if is_pid(Process.whereis(:remote_receiver)) do
        Process.unregister(:remote_receiver)
      end
      Process.exit(stream_pid, :kill)
    end)

    {:ok, stream_pid: stream_pid}
  end

  describe "gen/1" do
    test "gen(:cows) starts cow data generation and sends remote data", %{stream_pid: _pid} do
      # Start generation for cows.
      CDStream.gen(:cows)
      # Manually trigger the scheduled generation event.
      Process.send(CDStream, :gen, [])
      # Assert that a message is received.
      assert_receive {:data, message}, 1500
      # Validate that the generated cow data is a map with expected keys.
      assert is_map(message)
      for key <- [:id, :lot_id, :weight, :feed_consumed_kg] do
        assert Map.has_key?(message, key)
      end
    end

    test "gen(:feedlots) starts feedlot data generation and sends remote data", %{stream_pid: _pid} do
      # Start generation for feedlots.
      CDStream.gen(:feedlots)
      # Manually trigger the scheduled generation event.
      Process.send(CDStream, :gen, [])
      # Assert that a message is received.
      assert_receive {:data, message}, 1500
      # Validate that the generated feedlot data is a map with expected keys.
      assert is_map(message)
      for key <- [:lot_id, :cows] do
        assert Map.has_key?(message, key)
      end
      # Each cow in the feedlot should have an id.
      Enum.each(message.cows, fn cow ->
        assert is_map(cow)
        assert Map.has_key?(cow, :id)
      end)
    end

    test "gen/1 with an invalid parameter outputs an error message" do
      output =
        capture_io(fn ->
          CDStream.gen(:invalid)
        end)

      assert output =~ "Cannot generate"
    end
  end

  describe "stop/0" do
    test "stop/0 stops the data generation cycle", %{stream_pid: _pid} do
      # Start generation.
      CDStream.gen(:cows)
      # Then stop generation.
      CDStream.stop()
      # Manually trigger the generation event.
      Process.send(CDStream, :gen, [])
      # Assert that no remote data message is received.
      refute_receive {:data, _message}, 1500
    end
  end
end
