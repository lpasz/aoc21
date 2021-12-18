defmodule SmokeBasin do
  def read_from_disk!(path \\ "lib/day9/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line |> String.graphemes() |> Enum.map(&String.to_integer/1)
    end)
  end

  def find_low_points(input) do
    input
    |> create_lookup_grid()
    |> find_low_points_in_grid()
  end

  def find_low_points_and_calc_risk(input) do
    input |> find_low_points() |> calculate_low_points_risk_level() |> Enum.sum()
  end

  def create_lookup_grid(input) do
    y_max = length(input)
    x_max = input |> hd() |> length()

    grid_index = for y <- 1..y_max, x <- 1..x_max, do: {y, x}

    flat_input = input |> List.flatten()

    grid_index
    |> Enum.zip(flat_input)
    |> Enum.sort(fn a, b -> a |> elem(0) |> elem(0) < b |> elem(0) |> elem(0) end)
    |> Enum.into(%{})
  end

  defp find_low_points_in_grid(grid) do
    Enum.filter(grid, fn {position, val} ->
      lower_than_all_neighbors?(grid, position, val)
    end)
  end

  defp lower_than_all_neighbors?(grid, position, val) do
    grid
    |> get_all_neighbors(position)
    |> Enum.all?(&(elem(&1, 1) > val))
  end

  defp get_all_neighbors(grid, position) do
    [up(grid, position), down(grid, position), left(grid, position), right(grid, position)]
    |> Enum.reject(&(&1 |> elem(1) |> is_nil()))
  end

  defp up(grid, {y, x}), do: {{y - 1, x}, Map.get(grid, {y - 1, x})}
  defp down(grid, {y, x}), do: {{y + 1, x}, Map.get(grid, {y + 1, x})}
  defp right(grid, {y, x}), do: {{y, x + 1}, Map.get(grid, {y, x + 1})}
  defp left(grid, {y, x}), do: {{y, x - 1}, Map.get(grid, {y, x - 1})}

  defp calculate_low_points_risk_level(low_points),
    do: Enum.map(low_points, &low_point_risk_level/1)

  defp low_point_risk_level({_position, low_point}), do: low_point + 1

  def sort_debug(inputs) do
    inputs
    |> Enum.sort(fn a, b ->
      if a |> elem(0) |> elem(0) == b |> elem(0) |> elem(0) do
        a |> elem(0) |> elem(1) < b |> elem(0) |> elem(1)
      else
        a |> elem(0) |> elem(0) < b |> elem(0) |> elem(0)
      end
    end)
  end

  def calc_biggest_basin_product(inputs) do
    grid = create_lookup_grid(inputs)

    low_points =
      grid
      |> find_low_points_in_grid()

    grid_map = Enum.into(grid, %{})

    Enum.reduce(low_points, {%{}, []}, fn
      {_, 9}, acc ->
        acc

      input = {position, _}, {already_visited, acc} ->
        if Map.has_key?(already_visited, position) do
          {already_visited, acc}
        else
          {already_visited, result} = do_calc_basin(grid_map, [input], already_visited)

          basin_size = result |> Map.keys() |> length()

          upd_acc =
            if single_low?(result) do
              [basin_size | acc]
            else
              IO.puts("Salveu")
              acc
            end

          {already_visited, upd_acc}
        end
    end)
    |> elem(1)
    |> IO.inspect()
    |> Enum.sort(:desc)
    |> IO.inspect()
    |> Enum.take(3)
    |> Enum.product()
  end

  defp single_low?(values) do
    sorted_values = values |> Map.keys() |> Enum.sort()

    case sorted_values do
      [n, n | _rest] -> false
      _ -> true
    end
  end

  defp diff_of(val1, val2, diff) do
    case {val1, val2} do
      {9, _} -> false
      {_, 9} -> false
      _ -> abs(val1 - val2) == diff
    end
  end

  # |> Enum.sort(fn a, b -> a |> elem(0) |> elem(0) < b |> elem(0) |> elem(0) end)

  def do_calc_basin(grid, start_point_list, already_passed \\ %{}, result \\ %{})
  def do_calc_basin(_grid, [], already_passed, result), do: {already_passed, result}

  def do_calc_basin(grid, [{position, val} | rest], already_passed, result) do
    basins =
      grid
      |> get_all_neighbors(position)
      |> Enum.filter(&diff_of(elem(&1, 1), val, 1))
      |> Enum.reject(&Map.has_key?(already_passed, elem(&1, 0)))

    do_calc_basin(
      grid,
      List.flatten([basins | rest]),
      Map.put_new(already_passed, position, val),
      Map.put_new(result, position, val)
    )
  end
end

SmokeBasin.read_from_disk!()
|> tap(fn input ->
  IO.puts("Day 9 - Example 1 - #{SmokeBasin.find_low_points_and_calc_risk(input)}")
end)
|> tap(fn input ->
  IO.puts("Day 9 - Example 2 -  786048 - #{SmokeBasin.calc_biggest_basin_product(input)}")
end)
