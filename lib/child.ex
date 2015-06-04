defmodule Child do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


end
