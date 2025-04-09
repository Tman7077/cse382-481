# test/feed_management/feed_cost_calculator_test.exs
defmodule FeedManagement.FeedCostCalculatorTest do
  use ExUnit.Case
  alias FeedManagement.FeedCostCalculator

  setup do
    # Start the GenServer before each test
    {:ok, pid} = FeedCostCalculator.start_link(nil)
    {:ok, pid: pid}
  end

  describe "calculate_feed_cost/2" do
    test "calculates the correct feed cost", %{pid: pid} do
      # Define feed data (with quantity and cost per unit)
      feed_data = [
        %{"quantity" => 50, "cost_per_unit" => 0.10},
        %{"quantity" => 30, "cost_per_unit" => 0.12}
      ]

      # Expected cost: (50 * 0.10) + (30 * 0.12) = 5.0 + 3.6 = 8.6
      expected_cost = 8.6

      # Call the GenServer to calculate the feed cost
      actual_cost = FeedCostCalculator.calculate_feed_cost(pid, feed_data)

      # Assert that the calculated cost matches the expected cost
      assert actual_cost == expected_cost
    end
  end
end
