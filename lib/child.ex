defmodule Child do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


  def init(:ok) do
    if Babysitter.random(25) == 13 do
      # IO.puts "Created a sociopath"
      {:ok, :sociopath}
    else
      # IO.puts "Created a normal child"
      {:ok, :normal}
    end
  end

  def handle_cast({:hot_potato, potato_pid, [], sitter_pid}, :normal) do
    case Potato.state(potato_pid) do
      :potato -> 
        IO.puts ""
        IO.puts "Won teh game!"
      :grenade -> 
        IO.write "!"
        Babysitter.killall(sitter_pid)
    end

    {:noreply, :normal}
  end

  def handle_cast({:hot_potato, potato_pid, children_pids, sitter_pid}, :normal) do
    
    case Potato.state(potato_pid) do
      :potato -> 
        IO.write "."
        [first_child | other_children] = children_pids
        Child.hot_potato(first_child, potato_pid, other_children, sitter_pid)
      :grenade -> 
        IO.write "!"
        Babysitter.killall(sitter_pid)
    end

    {:noreply, :normal}
  end

  def handle_cast({:hot_potato, potato_pid, children_pids, sitter_pid}, :sociopath) do
    case Potato.state(potato_pid) do
      :potato -> 
        # IO.puts "Got a hot potato!"
        Potato.kill(potato_pid)
      :grenade -> 
        IO.write "!"
        Babysitter.killall(sitter_pid)
    end

    # IO.puts "Passing a grenade (I'm a sociopath)!"

    [first_child | other_children] = children_pids
    Child.hot_potato(first_child, potato_pid, other_children, sitter_pid)

    {:noreply, :sociopath}
  end

  def handle_cast({:hot_potato, potato_pid, [], sitter_pid}, :sociopath) do
    case Potato.state(potato_pid) do
      :potato -> 
        IO.puts "Sociopath Won teh game!"
      :grenade -> 
        IO.write "!"
        Babysitter.killall(sitter_pid)
    end

    {:noreply, :sociopath}
  end  

  def hot_potato(pid, potato_pid, children_pids, sitter_pid) do
    GenServer.cast(pid, {:hot_potato, potato_pid, children_pids, sitter_pid})

  end
end
