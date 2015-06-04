defmodule Potato do
  use GenServer

  def start_link do
    pid = GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:ok, :potato}
  end

  def handle_call({:state}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:kill}, state) do
    {:noreply, :grenade}
  end

  def state(server) do
    GenServer.call(server, {:state})
  end
  
  def kill(server) do
    GenServer.cast(server, {:kill})
  end



end
