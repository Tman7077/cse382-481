# Write documentation and unit tests for non-facade functions, only for handle_call and handle_cast
#make call to moolixir droplet on digital ocean, from local linux terminal. Test.
#use gpt to help generate unit tests!


defmodule FeedManagement.FeedDataManager do
  @moduledoc """
  Manages feed data for the cattle tracking system.

  This GenServer is responsible for storing and retrieving feed data. It provides
  public functions to add new feed records and retrieve existing feed records.
  The feed data is stored in the GenServer’s state as a list.

  ## Features

    * Adds new feed data to an internal list
    * Retrieves stored feed data on request

  @author Jackson Hammond
  @version 1.0
  @complexity Low – stores and retrieves data from the state in memory.
  @since 2025-04-09
  """

  # Starts the GenServer
  @doc """
  Starts the `FeedDataManager` GenServer.

  ## Parameters
    - `initial_state`: The initial state of the GenServer, typically an empty map.

  ## Examples
      iex> FeedDataManager.start_link(%{})
      {:ok, pid}

  @complexity Low – basic GenServer start.
  @since 2025-04-09
  """
  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  # Initializes the GenServer's state
  @doc """
  Initializes the GenServer with the given `initial_state`.

  ## Parameters
    - `initial_state`: The initial state (typically an empty map).

  ## Examples
      iex> FeedDataManager.init(%{})
      {:ok, %{}}

  @complexity Low – state initialization.
  @since 2025-04-09
  """
  def init(initial_state) do
    {:ok, initial_state}
  end

  # Public API to add feed data
  @doc """
  Adds new feed data to the GenServer's state.

  This function sends a cast message to the GenServer to append `feed_data` to the list
  of feed data stored in its state.

  ## Parameters
    - `pid`: The PID of the `FeedDataManager` GenServer.
    - `feed_data`: The feed data to be added (should be structured, e.g., a map).

  ## Examples
      iex> FeedDataManager.add_feed_data(pid, %{type: "hay", amount: 10})
      :ok

  @complexity Low – single cast operation and list append.
  @since 2025-04-09
  """
  def add_feed_data(pid, feed_data) do
    GenServer.cast(pid, {:add_feed, feed_data})
  end

  # Public API to retrieve feed data
  @doc """
  Retrieves the stored feed data from the GenServer.

  This function sends a call message to the GenServer to retrieve the current feed data
  stored in its state.

  ## Parameters
    - `pid`: The PID of the `FeedDataManager` GenServer.

  ## Examples
      iex> FeedDataManager.get_feed_data(pid)
      [%{type: "hay", amount: 10}, %{type: "corn", amount: 15}]

  @complexity Low – single call operation to fetch data.
  @since 2025-04-09
  """
  def get_feed_data(pid) do
    GenServer.call(pid, :get_feed_data)
  end

  # Handle incoming feed data (adding it to the state)
  @doc """
  Handles the `:add_feed` cast and updates the state with the new feed data.

  This function appends the new `feed_data` to the list of existing feed data in the state.

  ## Parameters
    - `{:add_feed, feed_data}`: A tuple containing the feed data to be added.
    - `state`: The current state of the GenServer, which is a map with a `:feed_data` list.

  ## Examples
      iex> FeedDataManager.handle_cast({:add_feed, %{type: "corn", amount: 15}}, %{feed_data: [%{type: "hay", amount: 10}]})
      {:noreply, %{feed_data: [%{type: "corn", amount: 15}, %{type: "hay", amount: 10}]}}

  @complexity Low – list manipulation and state update.
  @since 2025-04-09
  """
  def handle_cast({:add_feed, feed_data}, state) do
    new_state = Map.update(state, :feed_data, [feed_data], fn existing_data ->
      [feed_data | existing_data]
    end)
    {:noreply, new_state}
  end

  # Handle call to retrieve feed data
  @doc """
  Handles the `:get_feed_data` call and replies with the stored feed data.

  This function retrieves the current list of feed data from the GenServer's state.

  ## Parameters
    - `:get_feed_data`: A call request to fetch the feed data.
    - `state`: The current state of the GenServer, which contains the feed data.

  ## Examples
      iex> FeedDataManager.handle_call(:get_feed_data, self(), %{feed_data: [%{type: "hay", amount: 10}]})
      {:reply, [%{type: "hay", amount: 10}], %{feed_data: [%{type: "hay", amount: 10}]}}

  @complexity Low – state retrieval operation.
  @since 2025-04-09
  """
  def handle_call(:get_feed_data, _from, state) do
    {:reply, state[:feed_data], state}
  end
end
