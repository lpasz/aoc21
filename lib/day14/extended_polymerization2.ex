defmodule ExtendedPolymerization do
  def read_from_disk!(path \\ "lib/day14/input.txt") do
    [[initial], _space, polymerization] =
      path
      |> File.read!()
      |> String.split("\n")
      |> Enum.chunk_by(&(&1 == ""))

    polymerization_table =
      polymerization
      |> Enum.map(fn line ->
        [key, val] = String.split(line, " -> ")
        {key, val}
      end)
      |> Enum.into(%{})

    initial_list = String.codepoints(initial)

    initial_map = create_initial_map(initial_list, %{})

    {initial_map, polymerization_table, hd(initial_list), List.last(initial_list)}
  end

  def create_initial_map([h1, h2 | rest], r) do
    new_r = Map.update(r, h1 <> h2, 1, &(&1 + 1))

    create_initial_map([h2 | rest], new_r)
  end

  def create_initial_map(_, r), do: r

  def sub_most_and_least_repeating_polymer_after_rounds(file \\ "lib/day14/input.txt", round) do
    {initial_map, polymerization_table, first, last} = read_from_disk!(file)

    polymer_pairs_after_n_round =
      polymer_pair_after_rounds(initial_map, polymerization_table, round)

    polymer_occurrences = count_each_polymer(polymer_pairs_after_n_round, first, last)

    most_repeated_polymer(polymer_occurrences) - least_repeated_polymer(polymer_occurrences)
  end

  defp polymer_pair_after_rounds(initial_map, polymerization_table, rounds) do
    Enum.reduce(1..rounds, initial_map, fn _, acc1 ->
      Enum.reduce(acc1, %{}, fn {key, val}, acc2 ->
        new_poly = Map.get(polymerization_table, key)
        [h1, h2] = String.codepoints(key)

        acc2
        |> Map.update(h1 <> new_poly, val, &(&1 + val))
        |> Map.update(new_poly <> h2, val, &(&1 + val))
      end)
    end)
  end

  defp most_repeated_polymer(polymer_occurrences) do
    {_max_key, max_val} = Enum.max_by(polymer_occurrences, fn {_key, val} -> val end)
    max_val
  end

  defp least_repeated_polymer(polymer_occurrences) do
    {_min_key, min_val} = Enum.min_by(polymer_occurrences, fn {_key, val} -> val end)
    min_val
  end

  defp count_each_polymer(
         polymer_pairs_after_n_round,
         first_initial_polymers,
         last_initial_polymers
       ) do
    Enum.reduce(polymer_pairs_after_n_round, %{}, fn {key, val}, acc ->
      [h1, h2] = String.codepoints(key)

      acc
      |> Map.update(h1, val, &(&1 + val))
      |> Map.update(h2, val, &(&1 + val))
    end)
    |> Enum.map(fn {key, val} -> {key, div(val, 2)} end)
    |> Enum.into(%{})
    |> Map.update(first_initial_polymers, 1, &(&1 + 1))
    |> Map.update(last_initial_polymers, 1, &(&1 + 1))
  end

  defp part_1 do
    sub_most_and_least_repeating_polymer_after_rounds(10)
  end

  def part_2 do
    sub_most_and_least_repeating_polymer_after_rounds(10)
  end
end
