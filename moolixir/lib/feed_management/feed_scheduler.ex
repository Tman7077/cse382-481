defmodule FeedManagement.FeedScheduler do
  @moduledoc """
  Handles periodic feed check scheduling.

  This GenServer is responsible for triggering feed checks at fixed intervals.
  It uses `Process.send_after/3` to schedule a `:check_feed` message and re-queues the task
  after each execution.

  ## Features

    * Periodic scheduling of feed check events
    * Dynamically reschedules checks using the internal interval state
    * Lightweight, reliable time-based task management

  @author Jackson Hammond
  @version 1.0
  @complexity Medium – involves timed message passing and state updates.
  @since 2025-04-09
  """

  @doc """
  Starts the FeedScheduler GenServer with the given state.

  ## Parameters
    - `state`: A map containing parameters such as the interval between feed checks.

  ## Example
      iex> FeedManagement.FeedScheduler.start_link(%{interval: 86400000})
      {:ok, pid}

  @complexity Medium – straightforward startup with parameter initialization.
  @since 2025-04-09
  """
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Initializes the FeedScheduler GenServer's state and schedules the first feed check.

  ## Parameters
    - `initial_state`: The initial state (should include an `:interval` key).

  ## Example
      iex> FeedManagement.FeedScheduler.init(%{interval: 86400000})
      {:ok, %{interval: 86400000}}

  @complexity Medium – sets up initial scheduling.
  @since 2025-04-09
  """
  def init(initial_state) do
    schedule_feed_check(86400000)  # 24 hours in milliseconds
    {:ok, initial_state}
  end

  @doc """
  Schedules the next feed check after a given interval.

  Uses `Process.send_after/3` to enqueue the `:check_feed` message to the current process.

  ## Parameters
    - `interval`: Time in milliseconds between feed checks.

  ## Example
      iex> FeedManagement.FeedScheduler.schedule_feed_check(10_000)
      :ok

  @complexity Medium – handles scheduling with time-based message passing.
  @since 2025-04-09
  """
  def schedule_feed_check(interval), do: Process.send_after(self(), :check_feed, interval)

  @doc """
  Handles the `:check_feed` message by performing a feed check and rescheduling the next one.

  Prints a message to indicate that a feed check is taking place, then schedules another feed check.

  ## Parameters
    - `:check_feed`: The scheduled message.
    - `state`: The current state of the GenServer (expected to include an `:interval` key).

  ## Example
      iex> FeedManagement.FeedScheduler.handle_info(:check_feed, %{interval: 86400000})
      {:noreply, %{interval: 86400000}}

  @complexity Medium – relies on scheduling and simple output side-effects.
  @since 2025-04-09
  """
  def handle_info(:check_feed, state) do
    IO.puts("Checking feed...")
    schedule_feed_check(state[:interval])
    {:noreply, state}
  end
end
