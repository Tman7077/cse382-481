defmodule FeedManagement.FeedScheduler do
  use GenServer

  # Starts the GenServer with an empty state
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    # Start a periodic feed check (every 24 hours)
    schedule_feed_check(86400000)  # 24 hours in milliseconds
    {:ok, state}
  end

  # Public API to schedule feed checks
  def schedule_feed_check(pid, interval) do
    GenServer.cast(pid, {:schedule_feed_check, interval})
  end

  # Handle the scheduling of feed check
  def handle_cast({:schedule_feed_check, interval}, state) do
    Process.send_after(self(), :feed_check, interval)
    {:noreply, state}
  end

  # Handle the feed check event
  def handle_info(:feed_check, state) do
    IO.puts("Performing feed check...")
    # Here you would call FeedDataManager to process feed data or perform actions
    # For example: FeedDataManager.process_feed_data()

    # Reschedule the next feed check
    schedule_feed_check(self(), 86400000)  # 24 hours
    {:noreply, state}
  end
end
