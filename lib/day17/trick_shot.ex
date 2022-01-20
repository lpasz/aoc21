defmodule TrickShot do
  def read_from_disk!(_path \\ "") do
    %{x: 70..96, y: -179..-124}
  end

  def part_1 do
    target_zone = read_from_disk!()

    max_y = initial_y_acceleration_for_max_y(target_zone)

    maximum_height_achieved(max_y)
  end

  def part_2 do
    target_zone = read_from_disk!()

    target_zone_points = for x <- target_zone.x, y <- target_zone.y, do: {x, y}

    target_zone_map =
      target_zone_points
      |> Enum.map(&{&1, true})
      |> Enum.into(%{})
      |> IO.inspect(label: :target_zone_map)

    in_target_zone? = &Map.get(target_zone_map, &1, false)

    ys = min_y.._ = all_initial_y_accelerations(target_zone)
    xs = _..max_x = all_initial_x_accelerations(target_zone)

    xs_ys = for x <- xs, y <- ys, do: {x, y}

    xs_ys
    |> Enum.filter(&probe_stay_in_target_zone?({0, 0}, &1, {max_x, min_y}, in_target_zone?))
    |> length()
  end

  defp probe_stay_in_target_zone?(position, acceleration, max_x_y, inside_target_zone?)

  defp probe_stay_in_target_zone?({x, y}, _, {xm, ym}, _) when x > xm or y < ym do
    false
  end

  defp probe_stay_in_target_zone?({x, y}, {xa, ya} = acceleration, max_x_y, inside_target_zone?) do
    new_position = {x + xa, y + ya}
    new_acceleration = recalculate_acceleration(acceleration)

    if inside_target_zone?.(new_position) do
      true
    else
      probe_stay_in_target_zone?(new_position, new_acceleration, max_x_y, inside_target_zone?)
    end
  end

  defp recalculate_acceleration({xa, ya}) do
    {recalculate_x_acceleration_due_to_drag(xa), recalculate_y_acceleration_due_to_gravity(ya)}
  end

  defp recalculate_x_acceleration_due_to_drag(xa) do
    cond do
      xa == 0 -> 0
      xa > 0 -> xa - 1
      xa < 0 -> xa + 1
    end
  end

  defp recalculate_y_acceleration_due_to_gravity(ys) do
    ys - 1
  end

  defp all_initial_y_accelerations(%{y: range} = target_zone) do
    y_acc = initial_y_acceleration_for_max_y(target_zone)
    lowest_y = Enum.min(range)

    lowest_y..y_acc
  end

  def all_initial_x_accelerations(%{x: x_min..x_max}) do
    min_x_acc = Enum.find(1..x_max, fn num -> triangular_number(num) >= x_min end)

    min_x_acc..x_max
  end

  def triangular_number(n, r \\ 0)
  def triangular_number(0, r), do: r

  def triangular_number(n, r) do
    triangular_number(n - 1, r + n)
  end

  defp initial_y_acceleration_for_max_y(%{y: range}) do
    lowest_y = Enum.min(range)

    abs(lowest_y) - 1
  end

  defp maximum_height_achieved(initial_y_acceleration, current_height \\ 0) do
    new_height = current_height + initial_y_acceleration

    cond do
      new_height > current_height ->
        maximum_height_achieved(initial_y_acceleration - 1, new_height)

      true ->
        current_height
    end
  end
end
