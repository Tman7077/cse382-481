defmodule FeedManagement.FeedDataManagerTest do
  use ExUnit.Case
  alias FeedManagement.FeedDataManager

  # Setup: Start a FeedDataManager with an empty list for feed_data.
  setup do
    {:ok, pid} = FeedDataManager.start_link(%{feed_data: []})
    {:ok, pid: pid}
  end

  describe "initial state" do
    test "returns an empty feed_data list initially", %{pid: pid} do
      # When no feed data is added, get_feed_data should return an empty list.
      assert FeedDataManager.get_feed_data(pid) == []
    end
  end

  describe "adding feed data" do
    test "adds a single feed entry", %{pid: pid} do
      entry = %{type: "hay", amount: 10}
      # Add a single feed entry.
      :ok = FeedDataManager.add_feed_data(pid, entry)

      # Verify that get_feed_data returns that one entry.
      assert FeedDataManager.get_feed_data(pid) == [entry]
    end

    test "accumulates multiple feed entries in LIFO order", %{pid: pid} do
      entry1 = %{type: "hay", amount: 10}
      entry2 = %{type: "corn", amount: 15}

      :ok = FeedDataManager.add_feed_data(pid, entry1)
      :ok = FeedDataManager.add_feed_data(pid, entry2)

      # Because we prepend new data, we expect entry2 at the head.
      assert FeedDataManager.get_feed_data(pid) == [entry2, entry1]
    end
  end

  describe "state consistency" do
    test "retrieval does not alter the state", %{pid: pid} do
      entry = %{type: "oats", amount: 5}
      :ok = FeedDataManager.add_feed_data(pid, entry)

      # Retrieve the state multiple times and confirm it stays the same.
      data1 = FeedDataManager.get_feed_data(pid)
      data2 = FeedDataManager.get_feed_data(pid)

      assert data1 == [entry]
      assert data2 == [entry]
    end
  end
end
