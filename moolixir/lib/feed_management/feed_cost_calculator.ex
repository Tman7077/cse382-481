defmodule FeedManagement.FeedCostCalculator do
  @moduledoc """
  Calculates the total feed cost based on provided feed data.

  This GenServer provides a synchronous API to calculate the total cost by multiplying
  the quantity of feed with the cost per unit. It can be extended in the future to support
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
  Starts the GenServer for feed cost calculations.

  ## Parameters
  - `_`: Unused parameter, initializes an empty state.

  ## Example
      iex> FeedCostCalculator.start_link(nil)
      {:ok, pid}
  """
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @doc """
  Calculates the total feed cost based on provided feed data.

  Accepts feed data in the form of a map or struct with quantity and cost per unit,
  then returns the total cost.

  ## Parameters

    - `pid`: The PID of the `FeedCostCalculator` GenServer.
    - `feed_data`: A map with `:quantity` and `:cost_per_unit` keys.

  ## Examples

      iex> FeedManagement.FeedCostCalculator.calculate_feed_cost(pid, [%{"quantity" => 50, "cost_per_unit" => 0.10}, %{"quantity" => 30, "cost_per_unit" => 0.12}])
      8.6

  @complexity Low – straightforward multiplication and reply via GenServer.call.
  @since 2025-04-09
  """
  def calculate_feed_cost(pid, feed_data) do
    GenServer.call(pid, {:calculate_feed_cost, feed_data})
  end

  @doc """
  Handles the feed cost calculation request and returns the total cost.

  This function processes the `feed_data`, calculates the total cost, and returns it.

  ## Parameters
    - `{:calculate_feed_cost, feed_data}`: A tuple containing the feed data to be processed.
    - `state`: The current state of the GenServer.

  ## Example
      iex> FeedCostCalculator.handle_call({:calculate_feed_cost, [%{"quantity" => 50, "cost_per_unit" => 0.10}]}, nil, %{})
      {:reply, 5.0, %{}}

  @complexity Low – basic arithmetic and state manipulation.
  @since 2025-04-09
  """
  def handle_call({:calculate_feed_cost, feed_data}, _from, state) do
    total_cost = Enum.reduce(feed_data, 0, fn %{"quantity" => qty, "cost_per_unit" => cost}, acc ->
      acc + (qty * cost)
    end)

    {:reply, total_cost, state}
  end
end
