defmodule AdventOfCode2021.Day1.Exercise1Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day1.Exercise1

  test "gets the number of depth increases" do
    depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    assert Exercise1.number_of_depth_increases(depths) == 7
  end
end
