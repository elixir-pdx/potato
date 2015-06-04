defmodule Babysitter do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    maxChildren = 50

    nChildren = random(maxChildren)

    range = 1..nChildren

    IO.inspect range

    children = Enum.map(range, fn(n) -> worker(Child, [], id: make_ref()) end)
    IO.inspect children

    supervise(children, strategy: :one_for_one)

  end

  def random(n) do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a, b, c)
    :random.uniform(n)
  end
end
