defmodule BanditBugTest do
  use ExUnit.Case
  doctest BanditBug

  test "greets the world" do
    assert BanditBug.hello() == :world
  end
end
