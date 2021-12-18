defmodule CrabAlign do
  def read_from_disk!(path \\ "lib/day7/input.txt") do
    path |> File.read!() |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def crab_aligngments_fuel_cost(crab_positions) do
    crab_positions
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> calc_fuel_for_positions()
  end

  def new_crab_aligngments_fuel_cost(crab_positions) do
    crab_positions
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> new_calc_fuel_for_positions()
  end

  defp calc_fuel_for_positions(crabs_in_positions) do
    {max, _} = crabs_in_positions |> Enum.max_by(&elem(&1, 0))
    {min, _} = crabs_in_positions |> Enum.min_by(&elem(&1, 0))

    min..max
    |> Enum.map(&calc_fuel_for_position(crabs_in_positions, &1))
  end

  defp calc_fuel_for_position(crabs_in_positions, position) do
    fuel =
      crabs_in_positions
      |> Enum.map(fn {posi, n_crabs} -> abs(posi - position) * n_crabs end)
      |> Enum.sum()

    {position, fuel}
  end

  defp new_calc_fuel_for_positions(crabs_in_positions) do
    {max, _} = crabs_in_positions |> Enum.max_by(&elem(&1, 0))
    {min, _} = crabs_in_positions |> Enum.min_by(&elem(&1, 0))

    min..max
    |> Enum.map(&new_calc_fuel_for_position(crabs_in_positions, &1))
  end

  defp new_calc_fuel_for_position(crabs_in_positions, position) do
    fuel =
      crabs_in_positions
      |> Enum.map(fn {posi, n_crabs} -> of(abs(posi - position)) * n_crabs end)
      |> Enum.sum()

    {position, fuel}
  end

  def of(0), do: 0

  def of(n) when n > 0 do
    Enum.reduce(1..n, &+/2)
  end

  def most_fuel_efficient(positions_and_fuels) do
    Enum.min_by(positions_and_fuels, &elem(&1, 1))
  end
end

# CrabAlign.read_from_disk!()
# |> CrabAlign.crab_aligngments_fuel_cost()
# |> CrabAlign.most_fuel_efficient()
# |> IO.inspect(label: :crab_align_position_fuel)

# CrabAlign.read_from_disk!()
# |> CrabAlign.new_crab_aligngments_fuel_cost()
# |> CrabAlign.most_fuel_efficient()
# |> IO.inspect(label: :crab_align_position_new_fuel)
