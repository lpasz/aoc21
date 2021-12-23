defmodule ExtendedPolymerization do
  def read_from_disk!(path \\ "lib/day14/input.txt") do
    [initial, _space, polymerization] =
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

    {initial, polymerization_table}
  end

  def polymerization(initial_polymer, polymerization_manual, result \\ "")

  def polymerization(initial_polymer, polymerization_manual, result)
      when is_binary(initial_polymer) do
    initial_polymer
    |> String.codepoints()
    |> polymerization(polymerization_manual, result)
  end

  def polymerization([a, b | rest], polymerization_manual, result) do
    new_polymer = Map.get(polymerization_manual, a <> b)

    polymerization([b | rest], polymerization_manual, result <> a <> new_polymer)
  end

  def polymerization([a], _polymerization_manual, result), do: result <> a
  def polymerization([], _polymerization_manual, result), do: result

  def part_1 do
    {input, lookup} = read_from_disk!("test/day14/input.txt")

    final_polymer =
      Enum.reduce(0..10, input, fn _, acc ->
        polymerization(acc, lookup)
      end)

    final_polymer_freq =
      final_polymer
      |> String.codepoints()
      |> Enum.frequencies()
      |> Enum.map(&elem(&1, 1))

    Enum.max(final_polymer_freq) - Enum.min(final_polymer_freq)
  end
end
