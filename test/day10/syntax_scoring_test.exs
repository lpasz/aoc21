defmodule SyntaxScoringTest do
  use ExUnit.Case

  import SyntaxScoring

  setup_all do
    input = read_from_disk!("test/day10/input.txt")
    [input: input]
  end

  test "sum compilation error points correctly", %{input: input} do
    assert 26397 == total_compilation_error(input)
  end

  test "sum autocomplete points", %{input: input} do
    assert 288_957 == total_autocompletion_points(input)
  end
end
