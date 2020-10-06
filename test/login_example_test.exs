defmodule LoginExampleTest do
  use ExUnit.Case
  doctest LoginExample

  test "greets the world" do
    assert LoginExample.hello() == :world
  end
end
