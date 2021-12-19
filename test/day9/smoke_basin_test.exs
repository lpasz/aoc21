defmodule SmokeBasinTest do
  use ExUnit.Case
  import SmokeBasin

  setup_all do
    input = read_from_disk!("test/day9/input.txt")
    [input: input]
  end

  test "find low point", %{input: input} do
    result = input |> create_grid() |> find_low_points() |> Enum.map(&elem(&1, 1))
    assert [1, 0, 5, 5] -- result == []
  end

  test "find risk from low points", %{input: input} do
    assert 15 == find_low_points_and_calc_risk(input)
  end

  test "find basins", %{input: input} do
    assert 1134 == calc_bassins(input)
  end
end
