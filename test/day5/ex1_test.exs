defmodule AdventOfCode2021.Day5.Exercise1Test do
  use ExUnit.Case
  import AdventOfCode2021.Day5.Exercise1

  test "can read from file correctly" do
    assert [
             %{x1: 0, y1: 9, x2: 5, y2: 9},
             %{x1: 8, y1: 0, x2: 0, y2: 8},
             %{x1: 9, y1: 4, x2: 3, y2: 4},
             %{x1: 2, y1: 2, x2: 2, y2: 1},
             %{x1: 7, y1: 0, x2: 7, y2: 4},
             %{x1: 6, y1: 4, x2: 2, y2: 0},
             %{x1: 0, y1: 9, x2: 2, y2: 9},
             %{x1: 3, y1: 4, x2: 1, y2: 4},
             %{x1: 0, y1: 0, x2: 8, y2: 8},
             %{x1: 5, y1: 5, x2: 8, y2: 2}
           ] == read_from_disk("test/day5/input.txt")
  end

  setup_all do
    [inputs: read_from_disk("test/day5/input.txt")]
  end

  test "only consider horizontal and vertical lines," <>
         "the number of points where at least two lines overlap",
       %{inputs: inputs} do
    assert [
             %{x1: 0, x2: 5, y1: 9, y2: 9},
             %{x1: 9, x2: 3, y1: 4, y2: 4},
             %{x1: 2, x2: 2, y1: 2, y2: 1},
             %{x1: 7, x2: 7, y1: 0, y2: 4},
             %{x1: 0, x2: 2, y1: 9, y2: 9},
             %{x1: 3, x2: 1, y1: 4, y2: 4}
           ] == only_horizontal_and_vertical_lines(inputs)
  end

  test "get grid positions", %{inputs: inputs} do
    assert %{max_x: 9, max_y: 9, min_x: 0, min_y: 0} == inputs_x_y_min_and_max(inputs)
  end

  test "get overlaped grid points", %{inputs: inputs} do
    assert 5 ==
             inputs
             |> only_horizontal_and_vertical_lines()
             |> overlap_diagram()
             |> List.flatten()
             |> Enum.count(&(&1 >= 2))
  end

  test "get overlaped grid points with diagonals", %{inputs: inputs} do
    assert 5 ==
             inputs
             |> overlap_diagram()
             |> IO.inspect()
             |> List.flatten()
             |> Enum.count(&(&1 >= 2))
  end
end
