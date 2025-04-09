defmodule FeedManagement.FeedSchedulerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias FeedManagement.FeedScheduler

  setup do
    # For testing, use a short interval (e.g., 100 ms) instead of 24 hours.
    interval = 100
    {:ok, pid} = FeedScheduler.start_link(%{interval: interval})
    {:ok, pid: pid, interval: interval}
  end

  describe "handle_info/2 for :check_feed" do
    test "prints checking feed message and reschedules the feed check", %{interval: interval} do
      captured_output =
        capture_io(fn ->
          # Directly invoke the handle_info callback with a test state.
          result = FeedScheduler.handle_info(:check_feed, %{interval: interval})
          # We expect the GenServer to reply with a noreply tuple and same state.
          assert result == {:noreply, %{interval: interval}}
        end)

      # Verify that the "Checking feed..." message is printed.
      assert captured_output =~ "Checking feed..."
    end
  end
end
