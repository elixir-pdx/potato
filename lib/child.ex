defmodule Child do
   def start(parent) do
      is_sociopath = :random.uniform < 0.04
      
      receive do
         {:neighbor, pid} -> hotpotato({pid, parent, is_sociopath})
      end
   end
   
   def hotpotato(state) do
      {neighbor, parent, is_sociopath} = state 
      receive do
         {:getpotato} -> havepotato(state)
	                 hotpotato(state);
	 {:timeout, _} -> hotpotato(state);
	 {:neighbor, pid} -> hotpotato({pid, parent, is_sociopath});
	 {:kill} -> ()
      end
   end

   def havepotato({neighbor, parent, is_sociopath}) do
      receive do
         {:timeout, parent} -> send(parent, {:loser, self})
         after
	    100 -> if is_sociopath do
	              send(parent, {:grenade})
		   else
	              send(neighbor, {:getpotato})
		   end
      end
   end
end
