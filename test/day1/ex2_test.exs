defmodule AdventOfCode2021.Day1.Exercise2Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day1.Exercise2

  test "gets the number of depth increases" do
    depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    assert Exercise2.number_of_depth_increases(depths) == 5
  end
end
