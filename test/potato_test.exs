defmodule PotatoTest do
  use ExUnit.Case

  test "run the parents" do
    Parent.start_link
  end
end
