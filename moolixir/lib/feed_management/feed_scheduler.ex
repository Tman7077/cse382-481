defmodule FeedManagement.FeedScheduler do
  @moduledoc """
  Handles periodic feed check scheduling.

  This GenServer is responsible for triggering feed checks at fixed time intervals.
  It schedules these checks using `Process.send_after/3` and re-queues the task
  after each execution.

  ## Features

    * Periodic scheduling of feed check events
    * Dynamically reschedules checks using internal interval state
    * Lightweight and reliable time-based execution pattern

  @author Jackson Hammond
  @version 1.0
  @complexity Medium – manages recurring events via timed message passing.
  @since 2025-04-09
  """

  @doc """
  Starts the FeedScheduler GenServer with the given state.

  ## Parameters
  - `state`: A map containing the interval for scheduling feed checks.

  ## Example
      iex> FeedScheduler.start_link(%{interval: 86400000})
      {:ok, pid}
  """
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Schedules the next feed check based on the given interval.

  This function calculates the next check time and uses `Process.send_after/3`
  to queue the `:feed_check` message.

  ## Parameters

    - `interval`: Time in milliseconds between feed checks.

  ## Examples

      iex> FeedManagement.FeedScheduler.schedule_feed_check(10_000)
      :ok

  @complexity Medium – uses Elixir process scheduling and state tracking.
  @since 2025-04-09
  """
  def schedule_feed_check(interval), do: Process.send_after(self(), :feed_check, interval)

  @doc """
  Handles the periodic feed check and reschedules the next check.

  This function is triggered when the scheduled time arrives. It performs
  the feed check and then schedules the next one.

  ## Parameters
    - `:feed_check`: A message received when it's time to check the feed.
    - `state`: The current state of the GenServer, which contains the interval.

  ## Example
      iex> FeedScheduler.handle_info(:feed_check, %{interval: 86400000})
      {:noreply, %{interval: 86400000}}

  @complexity Medium – time-based message passing and state update.
  @since 2025-04-09
  """
  def handle_info(:feed_check, state) do
    IO.puts("Checking feed...")
    schedule_feed_check(state[:interval])  # Reschedule feed check
    {:noreply, state}
  end
end
