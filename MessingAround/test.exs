defmodule Feedlot do
  use GenServer

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def add_cattle(tag, weight) do
    GenServer.call(__MODULE__, {:add_cattle, tag, weight})
  end

  def update_weight(tag, new_weight) do
    GenServer.call(__MODULE__, {:update_weight, tag, new_weight})
  end

  def record_feed(tag, feed_type, amount) do
    GenServer.call(__MODULE__, {:record_feed, tag, feed_type, amount})
  end

  def get_cattle(tag) do
    GenServer.call(__MODULE__, {:get_cattle, tag})
  end

  # Server Callbacks
  def init(_) do
    {:ok, %{}}  # Initial state is an empty map
  end

  def handle_call({:add_cattle, tag, weight}, _from, state) do
    if Map.has_key?(state, tag) do
      {:reply, {:error, "Cattle already exists"}, state}
    else
      {:reply, :ok, Map.put(state, tag, %{weight: weight, feed_log: []})}
    end
  end

  def handle_call({:update_weight, tag, new_weight}, _from, state) do
    case Map.get(state, tag) do
      nil -> {:reply, {:error, "Cattle not found"}, state}
      cattle ->
        updated_cattle = Map.put(cattle, :weight, new_weight)
        {:reply, :ok, Map.put(state, tag, updated_cattle)}
    end
  end

  def handle_call({:record_feed, tag, feed_type, amount}, _from, state) do
    case Map.get(state, tag) do
      nil -> {:reply, {:error, "Cattle not found"}, state}
      cattle ->
        updated_feed_log = [%{type: feed_type, amount: amount} | cattle.feed_log]
        updated_cattle = Map.put(cattle, :feed_log, updated_feed_log)
        {:reply, :ok, Map.put(state, tag, updated_cattle)}
    end
  end

  def handle_call({:get_cattle, tag}, _from, state) do
    case Map.get(state, tag) do
      nil -> {:reply, {:error, "Cattle not found"}, state}
      cattle -> {:reply, {:ok, cattle}, state}
    end
  end
end
