defmodule FeedManagement.FeedCostCalculatorTest do
  use ExUnit.Case
  alias FeedManagement.FeedCostCalculator

  setup do
    {:ok, pid} = FeedCostCalculator.start_link(nil)
    {:ok, pid: pid}
  end

  describe "calculate_feed_cost/2" do
    test "calculates total feed cost correctly for a single entry", %{pid: pid} do
      # Given one feed entry with quantity 10 and cost per unit 2.5
      feed_data = [%{"quantity" => 10, "cost_per_unit" => 2.5}]
      expected_cost = 25.0
      assert FeedCostCalculator.calculate_feed_cost(pid, feed_data) == expected_cost
    end

    test "calculates total feed cost correctly for multiple entries", %{pid: pid} do
      # Given multiple feed entries
      feed_data = [
        %{"quantity" => 50, "cost_per_unit" => 0.10},  # Cost: 5.0
        %{"quantity" => 30, "cost_per_unit" => 0.12}   # Cost: 3.6
      ]
      expected_cost = 5.0 + 3.6  # 8.6 total
      assert FeedCostCalculator.calculate_feed_cost(pid, feed_data) == expected_cost
    end

    test "returns 0 if no feed data provided", %{pid: pid} do
      assert FeedCostCalculator.calculate_feed_cost(pid, []) == 0
    end
  end
end
