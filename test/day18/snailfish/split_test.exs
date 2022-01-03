defmodule Snailfish.SplitTest do
  use ExUnit.Case

  import Snailfish.Split

  test "split" do
    assert {:ok, [[5, 5], 1]} == split([10, 1])
    assert {:ok, [[5, 6], 1]} == split([11, 1])
    assert {:ok, [[6, 6], 1]} == split([12, 1])
  end
end
