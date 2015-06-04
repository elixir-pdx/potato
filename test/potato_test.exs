defmodule PotatoTest do
  use ExUnit.Case

  test "run the parents" do
    {_, pid} = Parent.start_link

    Parent.go_out(pid)

    :timer.sleep(5000)
  end
end
