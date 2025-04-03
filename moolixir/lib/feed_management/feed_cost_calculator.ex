defmodule FeedManagement.FeedCostCalculator do
  use GenServer

  # Starts the GenServer with an empty state
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  # Public API to calculate feed cost
  def calculate_feed_cost(pid, feed_data) do
    GenServer.call(pid, {:calculate_feed_cost, feed_data})
  end

  # Handle call to calculate feed cost based on feed data
  def handle_call({:calculate_feed_cost, feed_data}, _from, state) do
    total_cost = Enum.reduce(feed_data, 0, fn %{"quantity" => qty, "cost_per_unit" => cost}, acc ->
      acc + (qty * cost)
    end)

    {:reply, total_cost, state}
  end
end
