defmodule FeedManagement.FeedScheduler do
  use GenServer

  # Starting the GenServer
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # Initialize the GenServer with initial state
  def init(initial_state) do
    schedule_feed_check(86400000)  # 24 hours in milliseconds
    {:ok, initial_state}
  end

  # Define the schedule_feed_check function
  defp schedule_feed_check(interval) do
    Process.send_after(self(), :check_feed, interval)
  end

  # Handle the scheduled feed check event
  def handle_info(:check_feed, state) do
    IO.puts("Checking feed...")
    schedule_feed_check(86400000)  # Schedule the next check
    {:noreply, state}
  end
end
