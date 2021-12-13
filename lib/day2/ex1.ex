defmodule AdventOfCode2021.Day2.Exercise1 do
  @type movements() :: :forward | :down | :up
  @type position() :: {movements, integer()}

  @allow_movements ~w(forward down up)
  def read_from_disk!(path \\ "./lib/day2/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn move ->
      [item, val] = String.split(move, " ")

      if item in @allow_movements do
        {String.to_atom(item), String.to_integer(val)}
      end
    end)
  end

  @spec calc_position([position()]) :: integer()
  def calc_position(positions) do
    calc_final_position(positions)
  end

  defp calc_final_position(positions, horizontal \\ 0, vertical \\ 0)
  defp calc_final_position([], horizontal, vertical), do: horizontal * vertical

  defp calc_final_position([head | rest], horizontal, vertical) do
    case head do
      {:forward, val} ->
        calc_final_position(rest, horizontal + val, vertical)

      {:down, val} ->
        calc_final_position(rest, horizontal, vertical + val)

      {:up, val} ->
        calc_final_position(rest, horizontal, vertical - val)
    end
  end
end

result =
  AdventOfCode2021.Day2.Exercise1.read_from_disk!()
  |> AdventOfCode2021.Day2.Exercise1.calc_position()

IO.puts("Day 2 - Exercise 1 - Result #{result}")
