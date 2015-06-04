defmodule Child do
   def start do
      receive do
         {:neighbor, pid} -> hotpotato(pid)
      end
   end
   
   def hotpotato(neighbor) do
      receive do
         {:getpotato} -> havepotato(neighbor)
	                 hotpotato(neighbor);
	 {:timeout, _} -> hotpotato(neighbor);
	 {:neighbor, pid} -> hotpotato(pid);
	 {:kill} -> ()
      end
   end

   def havepotato(neighbor) do
      receive do
         {:timeout, parent} -> send(parent, {:loser, self})
         after
	    87 -> send(neighbor, {:getpotato})
      end
   end
end
