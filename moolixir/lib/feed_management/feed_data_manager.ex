defmodule FeedManagement.FeedDataManager do
  use GenServer

  # Initialize state
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    # Initialize your state here (e.g., tracking feed data)
    {:ok, initial_state}
  end

  # Public API to start tracking feed
  def start_tracking(pid) do
    GenServer.cast(pid, :start_tracking)
  end

  def stop_tracking(pid) do
    GenServer.cast(pid, :stop_tracking)
  end

  def get_feed_data(pid) do
    GenServer.call(pid, :get_feed_data)
  end

  # Handle messages to start/stop tracking or fetch data
  def handle_cast(:start_tracking, state) do
    # Logic for starting the feed tracking (e.g., scheduling feed events)
    {:noreply, state}
  end

  def handle_cast(:stop_tracking, state) do
    # Logic for stopping the feed tracking
    {:noreply, state}
  end

  def handle_call(:get_feed_data, _from, state) do
    # Return feed data
    {:reply, state, state}
  end
end
