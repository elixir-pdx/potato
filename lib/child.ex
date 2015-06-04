defmodule Child do
  use GenServer

  def start_link do
    pid = GenServer.start_link(__MODULE__, :ok)

    IO.inspect pid
  end


end
