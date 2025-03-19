defmodule DataIngestion.CattleDataSender do
  @moduledoc """
  Sends off cattle data
    as if from a real-world source.
  """
  use GenStateMachine

  @spec start_link(atom()) :: {:ok, pid()}
  def start_link(where) do
    GenStateMachine.start_link(__MODULE__, where, name: __MODULE__)
  end

  @spec init(atom()) :: {:ok, atom(), :ok}
  def init(where) do
    {:ok, where, :ok}
  end

  @doc """
  Sends a message to a remote receiver (specified by the state `where`).
  """
  @spec send_remote(map()) :: :ok
  def send_remote(message) do
    GenServer.cast(__MODULE__, {:send, message})
  end

  @doc """
  Handles incoming events.
  - `:cast` events are used to send data to a remote receiver.
  """
  @spec handle_event(atom(), tuple(), atom(), :ok) :: {:keep_state, atom()}
  def handle_event(:cast, {:send, message}, where, _) do
    {:remote_receiver, where} |> send({:data, message})
    {:keep_state, where}
  end
end
