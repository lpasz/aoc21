defmodule AdventOfCode2021.Day3.Exercise1Test do
  use ExUnit.Case
  alias AdventOfCode2021.Day3.Exercise1

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

  test "get the gamma rate", %{inputs: inputs} do
    assert Exercise1.gamma_rate(inputs) == 22
  end

  test "get the epsilon rate", %{inputs: inputs} do
    assert Exercise1.episilon_rate(inputs) == 9
  end

  test "power consumption", %{inputs: inputs} do
    assert Exercise1.power_consumption(inputs) == 198
  end
end
