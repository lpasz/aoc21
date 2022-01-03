defmodule Snailfish.ExplodeTest do
  use ExUnit.Case

  import Snailfish.Explode

  test "explode" do
    assert {:ok, [[[[0, 9], 2], 3], 4]} == explode([[[[[9, 8], 1], 2], 3], 4])
    assert :error == explode([[[[0, 9], 2], 3], 4])
    assert {:ok, [7, [6, [5, [7, 0]]]]} == explode([7, [6, [5, [4, [3, 2]]]]])
    assert {:ok, [[6, [5, [7, 0]]], 3]} == explode([[6, [5, [4, [3, 2]]]], 1])

    assert {:ok, [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]} ==
             explode([[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]])

    assert {:ok, [[3, [2, [8, 0]]], [9, [5, [7, 0]]]]} ==
             explode([[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]])
  end
end
