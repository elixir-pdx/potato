defmodule Parent do
	use Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, [])
	end

	def init([]) do
		children = [
			supervisor(Babysitter, [5])
		]

		supervise(children, strategy: :one_for_one, max_restarts: 2)
	end
end
