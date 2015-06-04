defmodule Parent do
   def start do
      spawn(Babysitter, :start, [self, 25])
      receive do
         {:winner, child} -> IO.puts("winner")
      end
   end
end
