defmodule Babysitter do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    maxChildren = 50

    nChildren = random(maxChildren)

    range = 1..nChildren

    # IO.inspect range

    children = Enum.map(range, fn(n) -> worker(Child, [], id: make_ref()) end)
    # IO.inspect children

    potato = worker(Potato, [], id: make_ref())

    children = [potato] ++ children

    IO.puts "Sitter is about to start the game"

    # supervise(children, strategy: :one_for_all, max_restarts: 3)
    supervise(children, strategy: :one_for_one)

    IO.inspect children
    IO.puts "Sitter started supervising"

    # play(self)
  end

  def play(pid) do
    IO.puts "Sitter has started the game!"
    IO.inspect pid

    all_processes = Supervisor.which_children(pid)

    IO.inspect all_processes

    [child_processes, [potato_process]] = Enum.chunk_by(all_processes, fn({_, _, _, [type]}) -> type == Child end)

    child_pids = Enum.map(child_processes, fn({_, pid, _, [Child]}) -> pid end)
    {_, potato_pid, _, [Potato]} = potato_process

    [first_child | shuffled_children] = Enum.shuffle(child_pids)

    Child.hot_potato(first_child, potato_pid, shuffled_children)
  end

  def random(n) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    :random.uniform(n)
  end
end
