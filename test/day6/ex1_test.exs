defmodule AdventOfCode2021.Day6.LanternFishTest do
  use ExUnit.Case

  import AdventOfCode2021.Day6.LanternFish

  setup_all do
    input = read_from_file!("test/day6/input.txt")

    [input: input]
  end

  for {days, expect} <- [{18, 26}, {80, 5934}, {256, 26_984_457_539}] do
    test "after #{days} days we have #{expect} fishes", %{input: input} do
      assert input |> reproduce_population(unquote(days)) == unquote(expect)
    end
  end
end
