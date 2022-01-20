defmodule SmokeBasin do
  def read_from_disk!(path \\ "lib/day9/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
  end

  def create_grid(grid) do
    grid
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      line
      |> Enum.with_index()
      |> Enum.map(fn {item, x} -> {{x, y}, item} end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  def find_low_points(input_map) do
    Enum.filter(input_map, fn {x_y, value} ->
      x_y
      |> get_neighbors(input_map)
      |> Enum.map(&elem(&1, 1))
      |> Enum.all?(&(&1 > value))
    end)
  end

  defp get_neighbors({x, y}, input_map) do
    [
      {{x - 1, y}, input_map[{x - 1, y}]},
      {{x + 1, y}, input_map[{x + 1, y}]},
      {{x, y - 1}, input_map[{x, y - 1}]},
      {{x, y + 1}, input_map[{x, y + 1}]}
    ]
    |> Enum.reject(fn {_, val} -> is_nil(val) end)
  end

  def calculate_risk(lowest_points) do
    lowest_points
    |> Enum.map(&(elem(&1, 1) + 1))
    |> Enum.sum()
  end

  def find_low_points_and_calc_risk(inputs) do
    inputs
    |> create_grid()
    |> find_low_points()
    |> calculate_risk()
  end

  def calc_bassins(inputs) do
    grid =
      inputs
      |> create_grid()
      |> Enum.reject(&(elem(&1, 1) == 9))
      |> Enum.into(%{})

    grid
    |> Enum.reduce({grid, []}, fn
      lowest_point, {still_not_in_bassin, bassins_sizes} ->
        {yet_still_not_in_bassin, bassin_size} =
          calculate_bassin([lowest_point], still_not_in_bassin)

        {yet_still_not_in_bassin, [bassin_size | bassins_sizes]}
    end)
    |> elem(1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp calculate_bassin(points, input_map, bassin_size \\ 0)

  defp calculate_bassin([], input_map, bassin_size),
    do: {input_map, bassin_size}

  defp calculate_bassin([{point, _value} | rest], input_map, bassin_size) do
    neighbors =
      point
      |> get_neighbors(input_map)
      |> Enum.filter(fn {point, _} -> Map.has_key?(input_map, point) end)

    # WTF
    # |> Enum.filter(fn {_, neightbor_value} -> abs(neightbor_value - value) == 1 end)

    if Map.has_key?(input_map, point) do
      input_map = Map.delete(input_map, point)

      [neighbors | rest]
      |> List.flatten()
      |> calculate_bassin(input_map, bassin_size + 1)
    else
      [neighbors | rest]
      |> List.flatten()
      |> calculate_bassin(input_map, bassin_size)
    end
  end
end

SmokeBasin.read_from_disk!()
|> tap(fn input ->
  IO.puts("Day 9 - Example 1 - #{SmokeBasin.find_low_points_and_calc_risk(input)}")
end)
|> tap(fn input ->
  IO.puts("Day 9 - Example 2 -  786048 - #{SmokeBasin.calc_bassins(input)}")
end)
