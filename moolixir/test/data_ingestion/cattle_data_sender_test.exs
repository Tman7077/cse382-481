defmodule CDSendTest do
  alias DataIngestion.CattleDataSender, as: CDSend
  use ExUnit.Case, async: false

  @current_node node()

  test "start_link/1 starts the sender process with the given state" do
    {:ok, pid} = CDSend.start_link(@current_node)
    assert is_pid(pid)
    # Clean up the sender process after test.
    Process.exit(pid, :kill)
  end

  test "send_remote/1 sends a message to the remote receiver" do
    # Start the sender process with the current node as its state.
    {:ok, pid} = CDSend.start_link(@current_node)

    # Register the current test process as the remote receiver.
    # This ensures that when the sender calls:
    #   send({:remote_receiver, @current_node}, {:data, message})
    # the message is delivered to self().
    Process.register(self(), :remote_receiver)

    test_message = %{foo: "bar"}
    CDSend.send_remote(test_message)

    # Assert that the test process receives the message.
    assert_receive {:data, ^test_message}, 500

    # Clean up by unregistering self() and terminating the sender process.
    Process.unregister(:remote_receiver)
    Process.exit(pid, :kill)
  end
end
