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

  # def at_most_one_small_cave(paths) do
  #   paths
  #   |> Enum.map(fn path -> Enum.reject(path, &(&1 in ~w(start end))) end)
  #   |> Enum.reject(fn path -> Enum.count(path, &small_cave?/1) > 1 end)
  #   |> Enum.count()
  # end

  def small_cave?(cave), do: not big_cave?(cave)

  def big_cave?(cave), do: String.upcase(cave) == cave

  def find_all_paths(
        paths,
        current_cave \\ "start",
        current_path \\ [],
        to_visit \\ [],
        complete_paths \\ []
      )

  def find_all_paths(paths, "end", current_path, [], complete_paths),
    do: [["end" | current_path] | complete_paths]

  def find_all_paths(paths, "end", current_path, [to_visit_path | to_visit_paths], complete_paths) do
    find_all_paths(
      paths,
      hd(to_visit_path),
      tl(to_visit_path),
      to_visit_paths,
      [["end" | current_path] | complete_paths]
    )
  end

  def find_all_paths(paths, current, current_path, to_visit_paths, complete_paths) do
    case next_possible_caves(paths, current, current_path) do
      [] ->
        case to_visit_paths do
          [] ->
            complete_paths

          [to_visit_path | to_visit_paths] ->
            find_all_paths(
              paths,
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

        find_all_paths(paths, next, new_current_path, to_visit_paths, complete_paths)
    end
  end

  defp next_possible_caves(paths, current_cave, visited) do
    case Map.get(paths, current_cave, []) do
      [] -> []
      next_caves -> Enum.reject(next_caves, &(small_cave?(&1) and &1 in visited))
    end
  end
end

PassagePathing.part_1()
