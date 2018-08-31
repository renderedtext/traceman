defmodule TracemanTest do
  use ExUnit.Case
  doctest Traceman

  test "greets the world" do
    assert Traceman.hello() == :world
  end
end
