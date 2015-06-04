defmodule Child do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


  def init(:ok) do
    if Babysitter.random(25) == 13 do
      IO.puts "Created a sociopath"
      {:ok, :sociopath}
    else
      IO.puts "Created a normal child"
      {:ok, :normal}
    end
  end

  def handle_call({:hot_potato, potato_pid, [], sitter_pid}, _from, :normal) do
    :potato = Potato.state(potato_pid)

    # We won
    IO.puts "Won teh game!"


    {:reply, :normal, :normal}
  end

  def handle_call({:hot_potato, potato_pid, children_pids, sitter_pid}, _from, :normal) do
    
    case Potato.state(potato_pid) do
      :potato -> IO.puts "Got a hot potato!"
        [first_child | other_children] = children_pids
        Child.hot_potato(first_child, potato_pid, other_children, sitter_pid)
      :grenade -> IO.puts "Got a grenade."
        Babysitter.killall(sitter_pid)
    end



    {:reply, :normal, :normal}
  end

  def handle_call({:hot_potato, potato_pid, children_pids, sitter_pid}, _from, :sociopath) do
    Potato.kill(potato_pid)

    IO.puts "Passing a grenade (I'm a sociopath)!"

    [first_child | other_children] = children_pids
    Child.hot_potato(first_child, potato_pid, other_children, sitter_pid)

    {:reply, :sociopath, :sociopath}
  end

  def hot_potato(pid, potato_pid, children_pids, sitter_pid) do
    GenServer.call(pid, {:hot_potato, potato_pid, children_pids, sitter_pid})

  end
end
