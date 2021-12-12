defmodule AdventOfCode2021.Day1.Exercise1 do
  @spec read_input_from_disk!(String.t()) :: [integer()]
  def read_input_from_disk!(path \\ "./lib/day1/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  @spec number_of_depth_increases([integer()]) :: integer()
  def number_of_depth_increases(depths) do
    {_, result} =
      Enum.reduce(depths, {nil, 0}, fn
        depth, {nil, inc} -> {depth, inc}
        depth, {last_depth, inc} -> {depth, if(depth > last_depth, do: inc + 1, else: inc)}
      end)

    result
  end
end

AdventOfCode2021.Day1.Exercise1.read_input_from_disk!()
|> AdventOfCode2021.Day1.Exercise1.number_of_depth_increases()
