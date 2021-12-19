defmodule PassagePathing do
  def part_1 do
    at_most_one_small_cave =
      read_from_disk!()
      |> find_all_paths()
      |> length()

    IO.puts(
      "How many paths through this cave system are there that visit small caves at most once? #{at_most_one_small_cave}"
    )
  end

  def part_2 do
    at_most_one_small_cave =
      read_from_disk!()
      |> find_all_paths_one_rep()
      |> length()

    IO.puts(
      "How many paths through this cave system are there that visit small caves at most once? #{at_most_one_small_cave}"
    )
  end

  def read_from_disk!(path \\ "lib/day12/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.reduce(%{}, fn [from, to], acc ->
      acc
      |> Map.update(from, [to], &[to | &1])
      |> Map.update(to, [from], &[from | &1])
    end)
  end

  def small_cave?(cave), do: not big_cave?(cave)

  def big_cave?(cave), do: String.upcase(cave) == cave

  def find_all_paths_one_rep(paths) do
    paths
    |> find_all_paths(&next_possible_caves_ex2/3)
    |> Enum.reject(fn l ->
      l
      |> Enum.reject(&(&1 == "start"))
      |> Enum.reject(&(&1 == "end"))
      |> Enum.reject(&big_cave?/1)
      |> Enum.frequencies()
      |> Enum.count(fn {_, n} -> n >= 2 end)
      |> Kernel.>(1)
    end)
  end

  def find_all_paths(
        paths,
        next_fun \\ &next_possible_caves/3,
        current_cave \\ "start",
        current_path \\ [],
        to_visit \\ [],
        complete_paths \\ []
      )

  def find_all_paths(paths, next_fun, "end", current_path, [], complete_paths),
    do: [["end" | current_path] | complete_paths]

  def find_all_paths(
        paths,
        next_fun,
        "end",
        current_path,
        [to_visit_path | to_visit_paths],
        complete_paths
      ) do
    find_all_paths(
      paths,
      next_fun,
      hd(to_visit_path),
      tl(to_visit_path),
      to_visit_paths,
      [["end" | current_path] | complete_paths]
    )
  end

  def find_all_paths(paths, next_fun, current, current_path, to_visit_paths, complete_paths) do
    case next_fun.(paths, current, current_path) do
      [] ->
        case to_visit_paths do
          [] ->
            complete_paths

          [to_visit_path | to_visit_paths] ->
            find_all_paths(
              paths,
              next_fun,
              hd(to_visit_path),
              tl(to_visit_path),
              to_visit_paths,
              complete_paths
            )
        end

      [next | nexts] ->
        new_current_path = [current | current_path]

        to_visit_paths =
          Enum.reduce(nexts, to_visit_paths, fn next, acc ->
            [[next | new_current_path] | acc]
          end)

        find_all_paths(paths, next_fun, next, new_current_path, to_visit_paths, complete_paths)
    end
  end

  defp next_possible_caves(paths, current_cave, visited) do
    case Map.get(paths, current_cave, []) do
      [] ->
        []

      next_caves ->
        next_caves
        |> Enum.reject(&(&1 == "start"))
        |> Enum.reject(&(small_cave?(&1) and &1 in visited))
    end
  end

  defp visited_twice_only_one?(cave, visited) do
    num_of_visited_twice =
      visited
      |> Enum.reject(&(&1 == "start"))
      |> Enum.filter(&small_cave?/1)
      |> Enum.frequencies()
      |> Enum.count(fn {_, num} -> num == 2 end)

    if num_of_visited_twice == 0 do
      # aka don't reject
      false
    else
      cave in visited
    end
  end

  defp next_possible_caves_ex2(paths, current_cave, visited) do
    case Map.get(paths, current_cave, []) do
      [] ->
        []

      next_caves ->
        next_caves
        |> Enum.reject(&(&1 == "start"))
        |> Enum.reject(&(small_cave?(&1) and visited_twice_only_one?(&1, visited)))
    end
  end
end

PassagePathing.part_1()
PassagePathing.part_2()
