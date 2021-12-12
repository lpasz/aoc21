defmodule AdventOfCode2021.Day1.Exercise2 do
  @spec number_of_depth_increases([integer()]) :: integer()
  def number_of_depth_increases(depths) do
    sliding_window_depth_inc(depths)
  end

  defp sliding_window_depth_inc(
         depths,
         prior_depth_windows \\ nil,
         result \\ 0
       )

  defp sliding_window_depth_inc([depth1, depth2, depth3 | rest], nil, result) do
    sliding_window_depth_inc(
      [depth2, depth3 | rest],
      depth1 + depth2 + depth3,
      result
    )
  end

  defp sliding_window_depth_inc([depth1, depth2, depth3 | rest], prior_depth_windows, result) do
    depths_sum = depth1 + depth2 + depth3

    result =
      if depths_sum > prior_depth_windows do
        result + 1
      else
        result
      end

    sliding_window_depth_inc(
      [depth2, depth3 | rest],
      depths_sum,
      result
    )
  end

  defp sliding_window_depth_inc(_, _, result), do: result
end
