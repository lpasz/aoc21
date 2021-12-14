defmodule AdventOfCode2021.Day3.Exercise2Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day3.Exercise2

  setup do
    [
      inputs: [
        [0, 0, 1, 0, 0],
        [1, 1, 1, 1, 0],
        [1, 0, 1, 1, 0],
        [1, 0, 1, 1, 1],
        [1, 0, 1, 0, 1],
        [0, 1, 1, 1, 1],
        [0, 0, 1, 1, 1],
        [1, 1, 1, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 0, 0, 1],
        [0, 0, 0, 1, 0],
        [0, 1, 0, 1, 0]
      ]
    ]
  end

  test "life support rating", %{inputs: inputs} do
    assert Exercise2.life_support_rating(inputs) == 230
  end

  test "CO2 scrubber rating", %{inputs: inputs} do
    assert Exercise2.co2_scrubber_rating(inputs) == [0, 1, 0, 1, 0]
  end

  test "oxygen generator rating", %{inputs: inputs} do
    assert Exercise2.oxygen_generator_rating(inputs) == [1, 0, 1, 1, 1]
  end
end
