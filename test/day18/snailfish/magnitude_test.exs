defmodule Snailfish.MagnitudeTest do
  use ExUnit.Case

  import Snailfish.Magnitude

  test "magnitude" do
    assert 29 == magnitude([9, 1])
    assert 21 == magnitude([1, 9])
    assert 129 == magnitude([[9, 1], [1, 9]])
    assert 143 == magnitude([[1, 2], [[3, 4], 5]])
    assert 1384 == magnitude([[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]])
    assert 445 == magnitude([[[[1, 1], [2, 2]], [3, 3]], [4, 4]])
    assert 791 == magnitude([[[[3, 0], [5, 3]], [4, 4]], [5, 5]])
    assert 1137 == magnitude([[[[5, 0], [7, 4]], [5, 5]], [6, 6]])
    assert 3488 == magnitude([[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]])
  end
end
