defmodule AdventOfCode2021.Day5.Exercise1 do
  def read_from_disk(path \\ "lib/day5/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line ->
      [x1, y1, x2, y2] =
        line
        |> String.split("->")
        |> Enum.map(&String.split(&1, ","))
        |> List.flatten()
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

      %{x1: x1, y1: y1, x2: x2, y2: y2}
    end)
  end

  def only_horizontal_and_vertical_lines(inputs) do
    Enum.filter(inputs, &horizontal_and_vertical_line?/1)
  end

  defp horizontal_and_vertical_line?(input) do
    input.x1 == input.x2 or input.y1 == input.y2
  end

  def overlap_diagram(inputs) do
    grid = inputs_x_y_min_and_max(inputs)

    empty_grid =
      for _x <- grid.min_x..grid.max_x do
        for _y <- grid.min_y..grid.max_y do
          0
        end
      end

    x_offset = grid.min_x

    y_offset = grid.min_y

    do_overlap(empty_grid, inputs, x_offset, y_offset)
  end

  defp do_overlap(grid, inputs, x_offset, y_offset) do
    case inputs do
      [input | rest] ->
        input_points = create_points(input, x_offset, y_offset)

        grid
        |> apply_points_to_grid(input_points)
        |> do_overlap(rest, x_offset, y_offset)

      [] ->
        grid
    end
  end

  defp apply_points_to_grid(grid, points) do
    case points do
      [%{x: x, y: y} | points] ->
        updated_grid =
          List.update_at(grid, y, fn line ->
            List.update_at(line, x, &(&1 + 1))
          end)

        apply_points_to_grid(updated_grid, points)

      [] ->
        grid
    end
  end

  def create_points(input, x_offset, y_offset) do
    for x <- input.x1..input.x2, y <- input.y1..input.y2do
      %{x: x - x_offset, y: y - y_offset}
    end
  end

  def inputs_x_y_min_and_max(inputs) do
    xs = inputs |> Enum.map(&[&1.x1, &1.x2]) |> List.flatten()
    ys = inputs |> Enum.map(&[&1.y1, &1.y2]) |> List.flatten()

    %{max_x: Enum.max(xs), max_y: Enum.max(ys), min_x: Enum.min(xs), min_y: Enum.min(ys)}
  end
end

AdventOfCode2021.Day5.Exercise1.read_from_disk()
|> AdventOfCode2021.Day5.Exercise1.only_horizontal_and_vertical_lines()
|> AdventOfCode2021.Day5.Exercise1.overlap_diagram()
|> List.flatten()
|> Enum.count(&(&1 >= 2))
|> IO.inspect()

# AdventOfCode2021.Day5.Exercise1.read_from_disk()
# # |> AdventOfCode2021.Day5.Exercise1.only_horizontal_and_vertical_lines()
# |> AdventOfCode2021.Day5.Exercise1.overlap_diagram()
# |> List.flatten()
# |> Enum.count(&(&1 >= 2))
# |> IO.inspect()
