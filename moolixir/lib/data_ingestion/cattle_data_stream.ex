defmodule DataIngestion.CattleDataStream do
  @moduledoc """
  Simulates the streaming of cattle data
    from a source such as a scale and tag scanner.
  """

  use GenStateMachine

  alias DataIngestion.DataGeneration.CattleDataGenerator, as: CDG

  @interval 2000  # milliseconds between data events

  def start_link do
    GenStateMachine.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, :stop, :ok}
  end

  def gen(:cows), do: GenStateMachine.cast(__MODULE__, {:start, :cows})
  def gen(:feedlots), do: GenStateMachine.cast(__MODULE__, {:start, :feedlots})
  def gen(other), do: IO.puts("Cannot generate #{inspect(other)}")

  def stop, do: Process.send(self(), :stop, [])

  def handle_event(:cast, {:start, which}, state, _) do
    if state != :stop, do: stop()
    schedule_generation(@interval)
    {:next_state, which, :ok}
  end

  def handle_event(:info, :gen, :cows, _) do
    print(CDG.gen_cow_data())
    schedule_generation(@interval)
    {:next_state, :cows, :ok}
  end
  def handle_event(:info, :gen, :feedlots, _) do
    print(CDG.gen_feedlot_data(:rand.uniform(10)))
    schedule_generation(@interval * 5)
    {:next_state, :feedlots, :ok}
  end
  def handle_event(:info, :gen, :stop, _) do
    {:next_state, :stop, :ok}
  end

  def handle_event(:info, :stop, _, _) do
    Process.send_after(self(), :gen, 10)
    {:next_state, :stop, :ok}
  end

  defp schedule_generation(interval) do
    Process.send_after(self(), :gen, interval)
  end

  defp print(map) do
    IO.puts("Generated data:")
    IO.inspect(
      map,
      pretty: true,
      syntax_colors: [atom: :cyan, string: :green, number: :yellow]
    )
  end
end
