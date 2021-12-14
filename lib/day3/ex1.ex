defmodule AdventOfCode2021.Day3.Exercise1 do
  @type input() :: [1 | 0]
  @type inputs() :: [input()]

  @spec read_from_disk!(String.t()) :: inputs()
  def read_from_disk!(path \\ "./lib/day3/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(fn codepoints -> Enum.map(codepoints, &String.to_integer/1) end)
  end

  @spec power_consumption(inputs()) :: integer()
  def power_consumption(inputs) do
    gamma_rate(inputs) * episilon_rate(inputs)
  end

  @spec gamma_rate(inputs()) :: integer()
  def gamma_rate(inputs) do
    inputs |> do_gama_rate() |> from_base_2_to_10()
  end

  defp do_gama_rate(inputs) do
    len_items = length(inputs)
    len_item = length(hd(inputs))

    threshold = Enum.map(1..len_item, fn _ -> div(-len_items, 2) end)

    [threshold | inputs]
    |> Enum.zip_with(& &1)
    |> Enum.map(&Enum.sum(&1))
    |> Enum.map(&if(&1 > 0, do: 1, else: 0))
    |> Integer.undigits()
  end

  defp from_base_2_to_10(val) do
    val |> to_string() |> Integer.parse(2) |> elem(0)
  end

  @spec episilon_rate(inputs()) :: integer()
  def episilon_rate(inputs) do
    inputs
    |> do_gama_rate()
    |> Integer.digits()
    |> Enum.map(fn
      0 -> 1
      1 -> 0
    end)
    |> Integer.undigits()
    |> from_base_2_to_10()
  end
end

results =
  AdventOfCode2021.Day3.Exercise1.read_from_disk!()
  |> AdventOfCode2021.Day3.Exercise1.power_consumption()

IO.puts("Day 3 - Exercise 1 - Result #{results}")
