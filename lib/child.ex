defmodule Child do
	use GenServer

	def start do
		GenServer.start(__MODULE__, [])
	end

	def init([]) do
		:random.seed(:os.timestamp)
		sociopath = :random.uniform(25) == 5

		{:ok, {sociopath, false}}
	end

	def is_sociopath?(pid) do
		GenServer.call(pid, :is_sociopath?)
	end

	def handle_call(:is_sociopath?, _from, {sociopath, has_potato}) do
		{:reply, sociopath, {sociopath, has_potato}}
	end

	def has_potato?(pid) do
		GenServer.call(pid, :has_potato?)
	end

	def handle_call(:has_potato?, _from, {sociopath, has_potato}) do
		{:reply, has_potato, {sociopath, has_potato}}
	end

	def handle_info(:pass, {false, has_potato}) do
		send(Babysitter, :next_child)
		{:noreply, {false, false}}
	end

	def handle_info(:pass, {true, has_potato}) do
		send(Babysitter, :blow_up)
		{:noreply, {true, false}}
	end
end
