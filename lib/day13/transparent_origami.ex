defmodule TransparentOrigami do
  def part_1 do
    {points, folds} = read_from_disk!()

    points_to_mark = parse_points(points)

    [fold | _] = parse_folds(folds)

    marked_invisible_paper = marked_invisible_paper(points_to_mark)

    fold(marked_invisible_paper, [fold])
    |> Enum.count(fn {_, val} -> val end)
  end

  def part_2 do
    {points, folds} = read_from_disk!()

    points_to_mark = parse_points(points)

    folds = parse_folds(folds)

    marked_invisible_paper = marked_invisible_paper(points_to_mark)

    marked_invisible_paper
    |> fold(folds)
    |> Enum.sort(&sort_by_y_x/2)
    |> Enum.group_by(fn {{_, y}, _} -> y end)
    |> Enum.reduce("", fn {_, vals}, acc ->
      acc <>
        "\n" <>
        Enum.reduce(vals, "", fn {_, val}, acc2 -> acc2 <> if(val, do: "x", else: " ") end)
    end)
    |> IO.puts
  end

  def sort_by_y_x({{x, y}, _}, {{xx, yy}, _}) do
    cond do
      y == yy -> x < xx
      true -> y < yy
    end
  end

  def read_from_disk!(path \\ "lib/day13/input.txt") do
    [points, _space, folds] =
      path |> File.read!() |> String.split("\n") |> Enum.chunk_by(&(&1 == ""))

    {points, folds}
  end

  def parse_points(points) do
    points
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn points -> Enum.map(points, fn point -> String.to_integer(point) end) end)
    |> Enum.map(fn [x, y] -> {x, y} end)
  end

  def parse_folds(folds) do
    folds
    |> Enum.map(&String.replace(&1, "fold along ", ""))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.map(fn [axis, val] -> {axis, String.to_integer(val)} end)
  end

  def marked_invisible_paper(points_to_mark) do
    marked_points = marked_points(points_to_mark)
    invisible_paper = invisible_paper(points_to_mark)

    Map.merge(invisible_paper, marked_points)
  end

  defp marked_points(points_to_mark) do
    points_to_mark
    |> Enum.map(fn {x, y} -> {{x, y}, true} end)
    |> Enum.into(%{})
  end

  defp invisible_paper(points_to_mark) do
    min_x = Enum.min_by(points_to_mark, fn {x, _} -> x end) |> elem(0)
    min_y = Enum.min_by(points_to_mark, fn {_, y} -> y end) |> elem(1)
    max_x = Enum.max_by(points_to_mark, fn {x, _} -> x end) |> elem(0)
    max_y = Enum.max_by(points_to_mark, fn {_, y} -> y end) |> elem(1)

    for x <- min_x..max_x, y <- min_y..max_y, into: %{}, do: {{x, y}, false}
  end

  def fold(invisible_paper, []), do: invisible_paper

  def fold(invisible_paper, [{axis, val} | rest]) do
    case axis do
      "x" -> fold_x(invisible_paper, val) |> fold(rest)
      "y" -> fold_y(invisible_paper, val) |> fold(rest)
    end
  end

  defp fold_y(marked_invisible_paper, fold_y) do
    stay_part =
      marked_invisible_paper
      |> Enum.filter(fn {{_, y}, _} -> y < fold_y end)
      |> Enum.into(%{})

    fold_part =
      marked_invisible_paper
      |> Enum.filter(fn {{_, y}, _} -> y > fold_y end)
      |> Enum.map(fn {{x, y}, val} -> {{x, folder_index_y(fold_y, y)}, val} end)
      |> Enum.into(%{})

    Map.merge(stay_part, fold_part, fn {x, y}, val1, val2 -> val1 or val2 end)
  end

  defp folder_index_y(y, n) do
    y - (n - (y + 0))
  end

  defp fold_x(marked_invisible_paper, fold_x) do
    stay_part =
      marked_invisible_paper
      |> Enum.filter(fn {{x, _}, _} -> x < fold_x end)
      |> Enum.into(%{})

    fold_part =
      marked_invisible_paper
      |> Enum.filter(fn {{x, _}, _} -> x > fold_x end)
      |> Enum.map(fn {{x, y}, val} -> {{folder_index_x(fold_x, x), y}, val} end)
      |> Enum.into(%{})

    Map.merge(stay_part, fold_part, fn {x, y}, val1, val2 -> val1 or val2 end)
  end

  defp folder_index_x(x, n) do
    x - (n - (x + 0))
  end
end
