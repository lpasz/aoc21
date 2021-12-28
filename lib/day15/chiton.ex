defmodule Chiton do
  def read_from_disk!(path \\ "lib/day15/input.txt", giga? \\ false) do
    points_chiton_risk =
      path
      |> File.read!()
      |> points_chiton_risk()
      |> maybe_giga_cave(giga?)

    cost_to_path_from_start = accumulated_path_risk_to_points(points_chiton_risk)

    {points_chiton_risk, cost_to_path_from_start}
  end

  defp maybe_giga_cave(points_chiton_risk, giga?) do
    if giga? do
      create_giga_cave(points_chiton_risk)
    else
      points_chiton_risk
    end
  end

  def create_giga_cave(points_chiton_risk, giga_times \\ 4) do
    {{finish_x, finish_y}, _} = Enum.max_by(points_chiton_risk, fn {{x, y}, _} -> x + y end)

    giga_skeleton = for i <- 0..giga_times, j <- 0..giga_times, do: {i, j}

    giga_skeleton
    |> Enum.reduce(points_chiton_risk, fn {x, y}, acc ->
      add = x + y

      Enum.map(points_chiton_risk, fn {{xx, yy}, val} ->
        new_val = ajust(val + add)

        {
          {xx + (finish_x + 1) * x, yy + (finish_y + 1) * y},
          new_val
        }
      end)
      |> Enum.into(%{})
      |> Map.merge(acc)
    end)
  end

  defp ajust(new_val) when new_val > 9, do: ajust(new_val - 9)
  defp ajust(new_val), do: new_val

  defp points_chiton_risk(text) do
    text
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.map(fn {line, y} ->
      Enum.map(line, fn {val, x} ->
        {{y, x}, val}
      end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  defp accumulated_path_risk_to_points(risk_of_points) do
    risk_of_points
    |> Enum.map(fn
      {{0, 0}, _} -> {{0, 0}, 0}
      {k, _v} -> {k, nil}
    end)
    |> Enum.into(%{})
  end

  def part_1 do
    {risk_of_points, cost_to_path_from_start} = read_from_disk!()

    calc(risk_of_points, cost_to_path_from_start)
  end

  defp calc(risk_of_points, cost_to_path_from_start) do
    updated_cost_to_path_from_start =
      risk_of_points
      |> Enum.sort(fn {x1, y1}, {x2, y2} -> if(x1 == x2, do: y1 <= y2, else: x1 <= x2) end)
      |> Enum.reduce(cost_to_path_from_start, fn current_point, acc ->
        lowest_risk_path(current_point, risk_of_points, acc)
      end)

    if cost_to_path_from_start == updated_cost_to_path_from_start do
      Enum.max_by(cost_to_path_from_start, fn {{x, y}, _} -> x + y end)
    else
      calc(risk_of_points, updated_cost_to_path_from_start)
    end
  end

  def part_2 do
    {risk_of_points, cost_to_path_from_start} = read_from_disk!("lib/day15/input.txt", true)

    calc(risk_of_points, cost_to_path_from_start)
  end

  defp lowest_risk_path(
         current_point,
         paths,
         cost_to_path_from_start
       ) do
    # Where can i go next
    next_points = next_possible_positions(current_point, paths)

    # Recalculates the cost to get to this point
    update_costs_to_reach_points(cost_to_path_from_start, current_point, next_points)
  end

  defp next_possible_positions({{x, y}, _}, paths) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.map(fn pos -> {pos, Map.get(paths, pos)} end)
    |> Enum.reject(fn {_pos, val} -> is_nil(val) end)
  end

  defp update_costs_to_reach_points(
         cost_to_path_from_start,
         {current_pos, _current_val},
         next_points
       ) do
    cost_to_current_point = Map.get(cost_to_path_from_start, current_pos)

    next_points
    |> Enum.reduce(cost_to_path_from_start, fn {next_pos, next_val}, acc ->
      # Load the cost to this next point if already exists
      old_cost_to_next_position = Map.get(acc, next_pos)

      # Calculate the new cost to the point
      new_cost_to_next_position = next_val + cost_to_current_point

      if old_cost_to_next_position != nil and
           old_cost_to_next_position < new_cost_to_next_position do
        acc
      else
        Map.put(acc, next_pos, new_cost_to_next_position)
      end
    end)
    |> Enum.into(%{})
  end
end
