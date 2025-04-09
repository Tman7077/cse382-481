defmodule FeedManagement.FeedCostCalculator do
  @moduledoc """
  Calculates the total feed cost based on provided feed data.

  This GenServer provides a synchronous API to calculate the total cost by multiplying
  the quantity of feed with its unit cost. It can be extended in the future to support
  more detailed cost tracking, logging, or auditing.

  ## Features

    * Stateless by default but supports future extensibility
    * Provides synchronous feed cost computation

  @author Jackson Hammond
  @version 1.0
  @complexity Low – performs a basic arithmetic operation per request.
  @since 2025-04-09
  """

  @doc """
  Starts the FeedCostCalculator GenServer.

  ## Parameters
    - `_`: An unused parameter; the GenServer initializes with an empty state.

  ## Example
      iex> FeedManagement.FeedCostCalculator.start_link(nil)
      {:ok, pid}

  @complexity Low – basic GenServer startup.
  @since 2025-04-09
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Initializes the FeedCostCalculator GenServer's state.

  ## Parameters
    - `state`: The initial state, typically an empty map.

  ## Example
      iex> FeedManagement.FeedCostCalculator.init(%{})
      {:ok, %{}}

  @complexity Low – basic state initialization.
  @since 2025-04-09
  """
  def init(state) do
    {:ok, state}
  end

  @doc """
  Calculates the total feed cost based on provided feed data.

  Accepts feed data in the form of a list of maps containing `quantity` and `cost_per_unit`,
  then returns the computed total cost.

  ## Parameters

    - `pid`: The PID of the `FeedCostCalculator` GenServer.
    - `feed_data`: A list of maps with each map containing `"quantity"` and `"cost_per_unit"` keys.

  ## Examples

      iex> FeedManagement.FeedCostCalculator.calculate_feed_cost(pid, [
      ...>   %{"quantity" => 50, "cost_per_unit" => 0.10},
      ...>   %{"quantity" => 30, "cost_per_unit" => 0.12}
      ...> ])
      8.6

  @complexity Low – straightforward arithmetic with a GenServer.call.
  @since 2025-04-09
  """
  def calculate_feed_cost(pid, feed_data) do
    GenServer.call(pid, {:calculate_feed_cost, feed_data})
  end

  @doc """
  Handles the feed cost calculation request by computing the total cost.

  Iterates over the provided feed data and sums up the product of quantity and cost per unit.

  ## Parameters
    - `{:calculate_feed_cost, feed_data}`: A tuple containing the feed data.
    - `_from`: The caller (ignored).
    - `state`: The current state of the GenServer.

  ## Example
      iex> FeedManagement.FeedCostCalculator.handle_call({:calculate_feed_cost, [%{"quantity" => 50, "cost_per_unit" => 0.10}]}, nil, %{})
      {:reply, 5.0, %{}}

  @complexity Low – basic arithmetic and state handling.
  @since 2025-04-09
  """
  def handle_call({:calculate_feed_cost, feed_data}, _from, state) do
    total_cost =
      Enum.reduce(feed_data, 0, fn %{"quantity" => qty, "cost_per_unit" => cost}, acc ->
        acc + (qty * cost)
      end)

    {:reply, total_cost, state}
  end
end
