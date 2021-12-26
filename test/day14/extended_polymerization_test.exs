defmodule ExtendedPolymerizationTest do
  use ExUnit.Case

  import ExtendedPolymerization

  test "subtract most by least repeated item on the polymer"do
    assert 1588 == sub_most_and_least_repeating_polymer_after_rounds("test/day14/input.txt", 10)

    assert 2_188_189_693_529 ==
             sub_most_and_least_repeating_polymer_after_rounds("test/day14/input.txt", 40)
  end
end
