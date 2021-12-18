defmodule AdventOfCode2021.Day6.LanternFish do
  def read_from_file!(path \\ "lib/day6/input.txt") do
    path
    |> File.read!()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn days_until_reproduction, acc ->
      Map.update(acc, days_until_reproduction, 1, &(&1 + 1))
    end)
  end

  def count_fishes(population) do
    population |> Map.values() |> Enum.sum()
  end

  def reproduce_population(starting_population, days_left)
  def reproduce_population(population, 0), do: count_fishes(population)

  def reproduce_population(population, days_left) do
    population
    |> day_step()
    |> reproduce_population(days_left - 1)
  end

  defp day_step(population) do
    Enum.reduce(population, %{}, fn
      {0, fish_reproducing}, population ->
        population
        |> Map.update(6, fish_reproducing, &(&1 + fish_reproducing))
        |> Map.update(8, fish_reproducing, &(&1 + fish_reproducing))

      {days_before_reproducing, day_fish_population}, population ->
        Map.update(
          population,
          days_before_reproducing - 1,
          day_fish_population,
          &(&1 + day_fish_population)
        )
    end)
  end
end

for {exercise, days} <- [{1, 80}, {2, 256}] do
  result =
    AdventOfCode2021.Day6.LanternFish.read_from_file!()
    |> AdventOfCode2021.Day6.LanternFish.reproduce_population(days)

  IO.puts("Day 5 - Exercise #{exercise} - Result #{result}")
end
