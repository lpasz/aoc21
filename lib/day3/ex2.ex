defmodule AdventOfCode2021.Day3.Exercise2 do
  def life_support_rating(inputs) do
    oxygen_generator_rate = oxygen_generator_rating(inputs) |> Integer.undigits(2)
    co2_scrubber_rate = co2_scrubber_rating(inputs) |> Integer.undigits(2)

    oxygen_generator_rate * co2_scrubber_rate
  end

  def oxygen_generator_rating(inputs) do
    do_rating(inputs, :one, 0)
  end

  def co2_scrubber_rating(inputs) do
    do_rating(inputs, :zero, 0)
  end

  defp do_rating([input], _importance_bit, _index), do: input

  defp do_rating(inputs, importance_bit, index) do
    filter_by_bit =
      inputs
      |> bit_ocurrence(index)
      |> important_bit(importance_bit)

    filtered_inputs =
      Enum.filter(inputs, fn input ->
        {bit_index, _} = List.pop_at(input, index)
        bit_index == filter_by_bit
      end)

    case filtered_inputs do
      [] -> do_rating(inputs, importance_bit, index + 1)
      _ -> do_rating(filtered_inputs, importance_bit, index + 1)
    end
  end

  defp bit_ocurrence(inputs, index) do
    {x, _} = inputs |> Enum.zip_with(& &1) |> List.pop_at(index)

    %{0 => zeros, 1 => ones} = Enum.group_by(x, & &1)

    %{zero: length(zeros), one: length(ones)}
  end

  defp important_bit(%{zero: zero, one: one}, :one) do
    case one - zero do
      0 -> 1
      x when x > 0 -> 1
      x when x < 0 -> 0
    end
  end

  defp important_bit(%{zero: zero, one: one}, :zero) do
    case one - zero do
      0 -> 0
      x when x > 0 -> 0
      x when x < 0 -> 1
    end
  end
end

results =
  AdventOfCode2021.Day3.Exercise1.read_from_disk!()
  |> AdventOfCode2021.Day3.Exercise2.life_support_rating()

IO.puts("Day 3 - Exercise 2 - Result #{results}")
