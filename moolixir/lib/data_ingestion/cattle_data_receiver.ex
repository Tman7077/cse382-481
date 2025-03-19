defmodule DataIngestion.CattleDataReceiver do
  @moduledoc """
  Simulates the reception of cattle data
    from a real-world source.
  """

  @doc """
  Starts the receiver process and registers it
    under the name `:remote_receiver`.
  """
  def start do
    pid = spawn(__MODULE__, :loop, [])
    Process.register(pid, :remote_receiver)
  end

  @doc """
  Loops, waiting for incoming messages.
  When a message is received, it calls the `print` function
    to display the data.
  """
  def loop do
    receive do
      {:data, map} ->
        print(map)
        loop()
    end
  end

  # Pretty-prints the generated map to the console.
  # The map is formatted with line breaks and colors
  #   for better readability.
  @spec print(map()) :: :ok
  defp print(map) do
    IO.puts("Generated data:")
    IO.inspect(
      map,
      pretty: true,
      syntax_colors: [
        atom: :cyan,
        string: :green,
        number: :yellow
      ]
    )
  end
end
