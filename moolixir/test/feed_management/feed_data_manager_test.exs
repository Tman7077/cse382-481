# test/feed_management/feed_data_manager_test.exs
defmodule FeedManagement.FeedDataManagerTest do
  use ExUnit.Case
  alias FeedManagement.FeedDataManager

  setup do
    {:ok, pid} = FeedDataManager.start_link(%{feed_data: []})
    {:ok, pid: pid}
  end

  describe "add_feed_data/2" do
    test "adds feed data correctly", %{pid: pid} do
      feed_data = %{cattle_id: "cow123", feed_type: "corn", quantity: 50, cost_per_unit: 0.10}
      FeedDataManager.add_feed_data(pid, feed_data)

      feed_data_list = FeedDataManager.get_feed_data(pid)

      assert length(feed_data_list) == 1
      assert hd(feed_data_list) == feed_data
    end
  end

  describe "get_feed_data/1" do
    test "retrieves feed data", %{pid: pid} do
      feed_data = %{cattle_id: "cow124", feed_type: "soy", quantity: 30, cost_per_unit: 0.12}
      FeedDataManager.add_feed_data(pid, feed_data)

      feed_data_list = FeedDataManager.get_feed_data(pid)

      assert length(feed_data_list) == 1
      assert hd(feed_data_list) == feed_data
    end
  end
end
