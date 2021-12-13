defmodule AdventOfCode2021.Day2.Exercise2 do
  alias AdventOfCode2021.Day2
  @spec calc_position([Day2.Exercise1.position()]) :: integer()
  def calc_position(positions) do
    calc_final_position(positions)
  end

  defp calc_final_position(positions, aim \\ 0, horizontal \\ 0, vertical \\ 0)
  defp calc_final_position([], _aim, horizontal, vertical), do: horizontal * vertical

  defp calc_final_position([{move, val} | rest], aim, horizontal, vertical) do
    case move do
      :forward ->
        calc_final_position(rest, aim, horizontal + val, vertical + aim * val)

      :down ->
        calc_final_position(rest, aim + val, horizontal, vertical)

      :up ->
        calc_final_position(rest, aim - val, horizontal, vertical)
    end
  end
end

result =
  AdventOfCode2021.Day2.Exercise1.read_from_disk!()
  |> AdventOfCode2021.Day2.Exercise2.calc_position()

IO.puts("Day 2 - Exercise 2 - Result #{result}")
