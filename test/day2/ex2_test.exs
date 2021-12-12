defmodule AdventOfCode2021.Day2.Exercise2Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day2.Exercise2

  test "gets the number of depth increases" do
    positions = [
      {:forward, 5},
      {:down, 5},
      {:forward, 8},
      {:up, 3},
      {:down, 8},
      {:forward, 2}
    ]

    assert Exercise2.calc_position(positions) == 900
  end
end
