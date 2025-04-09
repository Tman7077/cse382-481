# test/feed_management/feed_scheduler_test.exs
defmodule FeedManagement.FeedSchedulerTest do
  use ExUnit.Case
  alias FeedManagement.FeedScheduler

  setup do
    {:ok, pid} = FeedScheduler.start_link(%{interval: 86400000}) # 24 hours in milliseconds
    {:ok, pid: pid}
  end

  describe "FeedScheduler" do
    test "schedules feed check", %{pid: pid} do
      # Ensure the FeedScheduler process is alive
      assert Process.alive?(pid)

      # Additional checks can be done here, like checking if the feed check message is sent after the interval
    end
  end
end
