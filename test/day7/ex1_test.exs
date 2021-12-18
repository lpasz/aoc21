defmodule CrabAlignTest do
  use ExUnit.Case

  test "provide the correct fuel for each position" do
    crab_positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

    results = CrabAlign.crab_aligngments_fuel_cost(crab_positions) |> Map.new()

    assert results[1] == 41
    assert results[2] == 37
    assert results[3] == 39
    assert results[10] == 71
  end

  test "provide the most fuel efficient" do
    crab_positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

    results =
      crab_positions |> CrabAlign.crab_aligngments_fuel_cost() |> CrabAlign.most_fuel_efficient()

    assert results == {2, 37}
  end

  test "new calc" do
    crab_positions = [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

    results =
      crab_positions |> CrabAlign.new_crab_aligngments_fuel_cost() |> CrabAlign.most_fuel_efficient()

    assert results == {5, 168}
  end
end
