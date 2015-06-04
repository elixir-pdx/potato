defmodule Parent do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      worker(Babysitter, [])
    ]

    return = supervise(children, strategy: :one_for_one, max_restarts: 2)
    # IO.inspect return
    return
  end

  def go_out(pid) do
    [{_, pid, _, [Babysitter]}] = Supervisor.which_children(pid)

    # Babysitter.play(pid)
  end
end
