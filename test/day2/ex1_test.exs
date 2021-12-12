defmodule AdventOfCode2021.Day2.Exercise1Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day2.Exercise1

  test "gets the number of depth increases" do
    positions = [
      {:forward, 5},
      {:down, 5},
      {:forward, 8},
      {:up, 3},
      {:down, 8},
      {:forward, 2}
    ]

    assert Exercise1.calc_position(positions) == 150
  end
end
