defmodule Potato do
	use GenServer

	def start do
		GenServer.start(__MODULE__, [], name: __MODULE__)
	end

	def init([]) do
		{:ok, nil}
	end

	def handle_info({:current_holder, pid}, _) do
		{:noreply, pid}
	end

	def current_holder do
		GenServer.call(__MODULE__, :current_holder)
	end

	def handle_call(:current_holder, _from, current_holder) do
		{:reply, current_holder, current_holder}
	end
end
