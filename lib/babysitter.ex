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
    supervise(children, strategy: :one_for_one)
    # IO.inspect children
  end

  def play(pid) do
    all_processes = Supervisor.which_children(pid)

    [child_processes, [potato_process]] = Enum.chunk_by(all_processes, fn({_, _, _, [type]}) -> type == Child end)

    child_pids = Enum.map(child_processes, fn({_, pid, _, [Child]}) -> pid end)
    {_, potato_pid, _, [Potato]} = potato_process

    IO.inspect potato_pid
    IO.inspect child_pids
  end

  def random(n) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    :random.uniform(n)
  end
end
