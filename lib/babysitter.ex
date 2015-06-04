defmodule Babysitter do
   def start(parent, num_children) do
      IO.puts("starting game with #{num_children} children")
      children = Enum.map(1..num_children, fn _ -> spawn(Child, :start, [parent]) end)
      play_game(parent, children)
   end

   def play_game(parent, children) do
      if length(children) == 1 do
         send(parent, {:winner, Enum.at(children, 0)})
      else 
         [head | tail] = children
         shifted = tail ++ [head]
         Enum.map(Enum.zip(children, shifted), fn {child, next} -> send(child, {:neighbor, next}) end)
         send(head, {:getpotato})
         receive do
            after
               1_000 -> Enum.map(children, fn child -> send(child, {:timeout, self}) end)
         end
         receive do
            {:loser, child} -> IO.puts(Enum.find_index(children, fn cid -> cid == child end))
	                       send(child, {:kill})
			       play_game(parent, Enum.filter(children, fn cid -> cid != child end))
            #{:grenade} -> kill
         end
      end
   end
end
