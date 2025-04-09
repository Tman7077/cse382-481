# Write documentation and unit tests for non-facade functions, only for handle_call and handle_cast
#make call to moolixir droplet on digital ocean, from local linux terminal. Test.
#use gpt to help generate unit tests!


defmodule FeedManagement.FeedDataManager do
  use GenServer

  # Starts the GenServer
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    {:ok, initial_state}
  end

  # Public API to add feed data
  def add_feed_data(pid, feed_data) do
    GenServer.cast(pid, {:add_feed, feed_data})
  end

  # Public API to retrieve feed data
  def get_feed_data(pid) do
    GenServer.call(pid, :get_feed_data)
  end

  # Handle incoming feed data (adding it to the state)
  def handle_cast({:add_feed, feed_data}, state) do
    new_state = Map.update(state, :feed_data, [feed_data], fn existing_data ->
      [feed_data | existing_data]
    end)
    {:noreply, new_state}
  end

  # Handle call to retrieve feed data
  def handle_call(:get_feed_data, _from, state) do
    {:reply, state[:feed_data], state}
  end
end


# example data
# {
#   cattle_id: "cow123",
#   feed_type: "corn",
#   quantity: 50,
#   cost_per_unit: 0.10,
#   date: "2025-04-03"
# }
# {
#   feedlot_id: "feedlot1",
#   total_feed_cost: 500.00,
#   feed_history: [
#     %{feed_type: "corn", quantity: 50, cost_per_unit: 0.10},
#     %{feed_type: "soy", quantity: 30, cost_per_unit: 0.12}
#   ]
# }
# example outgoing data
# {
#   feedlot_id: "feedlot1",
#   total_feed_cost: 500.00,
#   feed_summary: [
#     %{feed_type: "corn", total_quantity: 50, total_cost: 5.00},
#     %{feed_type: "soy", total_quantity: 30, total_cost: 3.60}
#   ]
# }
