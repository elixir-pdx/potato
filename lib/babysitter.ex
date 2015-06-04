defmodule Babysitter do
	use GenServer

	def start_link(num_children) do
		GenServer.start_link(__MODULE__, [num_children], name: __MODULE__)
	end

	def init([num_children]) do
		children = 0..num_children |> Enum.map(fn(_) -> 
			{:ok, pid} = Child.start
			pid
		end)

		Potato.start

		send(self, :start_game)

		{:ok, {children, 0}}
	end

	def handle_info(:start_game, {children, index_of_next_child}) do
		IO.puts("You kids want to play a game?")
		
		mypid = self
		interval = :random.uniform(2) + 1
		:timer.send_after(interval, mypid, :times_up)

		send(self, :next_child)
		{:noreply, {children, 0}}
	end

	def handle_info(:next_child, {children, index_of_next_child}) do
		next_child = Enum.at(children, index_of_next_child)
		if index_of_next_child + 1 >= Enum.count(children) do
			index_of_next_child = 0
		else
			index_of_next_child = index_of_next_child + 1
		end

		send(Potato, {:current_holder, next_child})
		send(next_child, :pass)

		{:noreply, {children, index_of_next_child}}
	end

	def handle_info(:times_up, {children, _index_of_next_child}) do
		dead_kid = Potato.current_holder
		IO.puts "killing: #{inspect dead_kid} (splat)"
		Process.exit(dead_kid, :kill)

		survivors = Enum.reject(children, fn(x) ->
			x == dead_kid
		end)

		if Enum.count(survivors) == 1 do
			IO.puts("And the winner is: #{inspect hd(survivors)}")
			{:stop, :normal, 0}
		else
			send(self, :start_game)
			{:noreply, {survivors, 0}}
		end
	end

	def terminate(:normal, _state) do
		:ok
	end

	def terminate(:grenade, children) do
		Enum.each(children, fn(child) ->
			Process.exit(child, :kill)
		end)
		:ok
	end

	def handle_info(:blow_up, {children, _}) do
		IO.puts("HAND GRENA---")
		{:stop, :grenade, children}
	end

	def handle_info(_give_kid_the_finger, state) do
		{:noreply, state}
	end
end
