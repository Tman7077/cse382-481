defmodule DataIngestion.CattleDataStream do
  @moduledoc """
  Simulates the streaming of cattle data
    from a source such as a scale and tag scanner.
  """

  use GenStateMachine

  alias DataIngestion.DataGeneration.CattleDataGenerator, as: CDG
  alias DataIngestion.CattleDataSender, as: CDSend

  @interval 1000  # milliseconds between data events

  ##### Initialization #####
  @spec start_link(atom()) :: {:ok, pid()}
  def start_link(where) do
    CDSend.start_link(where)
    GenStateMachine.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec init(:ok) :: {:ok, :stop, %{timer_ref: nil}}
  def init(:ok) do
    {:ok, :stop, %{timer_ref: nil}}
  end


  ##### Public API #####
  @doc """
  Starts the data generation process for the specified type of cattle data.
  The type can be either `:cows` or `:feedlots`.
  Starting generation will stop any other current generation cycles.
  """
  @spec gen(atom()) :: :ok | :error
  def gen(:cows), do: GenStateMachine.cast(__MODULE__, {:start, :cows})
  def gen(:feedlots), do: GenStateMachine.cast(__MODULE__, {:start, :feedlots})
  def gen(other), do: IO.puts("Cannot generate #{inspect(other)}")

  @doc """
  Manually stop generation of data.
  """
  @spec stop() :: :ok
  def stop, do: GenStateMachine.cast(__MODULE__, :stop)


  ##### GenStateMachine callbacks #####
  @doc """
  Handles incoming events.
  - `:cast` events are used to start or stop data generation.
  - `:info` events are used to repeatedly generate data based on `@interval`.
  """
  @spec handle_event(atom(), atom() | tuple(), atom(), map()) :: {:next_state, atom(), map()} | {:keep_state, map()}
  # Starts data generation, stopping previous generation if it is going.
  def handle_event(:cast, {:start, which}, _, data) do
    if data.timer_ref, do: Process.cancel_timer(data.timer_ref)
    timer_ref = schedule_generation(@interval)
    {:next_state, which, %{timer_ref: timer_ref}}
  end

  # Stops data generation, cancelling any previously running generation cycles.
  def handle_event(:cast, :stop, _, data) do
    if data.timer_ref, do: Process.cancel_timer(data.timer_ref)
    {:next_state, :stop, %{data | timer_ref: nil}}
  end

  # Repeatedly calls generation based on gen type
    # (`:cows` or `:feedlots`),
    # using the `@interval` to determine the time between generations.
  def handle_event(:info, :gen, :cows, %{timer_ref: _} = data) do
    message = CDG.gen_cow_data()
    # print(message)
    CDSend.send_remote(message)
    timer_ref = schedule_generation(@interval)
    {:keep_state, %{data | timer_ref: timer_ref}}
  end
  def handle_event(:info, :gen, :feedlots, %{timer_ref: _} = data) do
    message = CDG.gen_feedlot_data(:rand.uniform(10))
    # print(message)
    CDSend.send_remote(message)
    timer_ref = schedule_generation(@interval * 5)
    {:keep_state, %{data | timer_ref: timer_ref}}
  end


  ##### Private functions #####

  # Schedules the next generation event.
  # `interval` is specified in milliseconds.
  @spec schedule_generation(integer()) :: reference()
  defp schedule_generation(interval) do
    Process.send_after(self(), :gen, interval)
  end

  # Pretty-prints the generated map to the console.
  # The map is formatted with line breaks and colors
  #   for better readability.
  # @spec print(map()) :: :ok
  # defp print(map) do
  #   IO.puts("Generated data:")
  #   IO.inspect(
  #     map,
  #     pretty: true,
  #     syntax_colors: [
  #       atom: :cyan,
  #       string: :green,
  #       number: :yellow
  #     ]
  #   )
  # end
end
