defmodule DisplaySignal do
  def read_from_disk!(path \\ "lib/day8/input.txt") do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&format_input_text/1)
  end

  def format_input_text(text) do
    [unique_digits, _, output_digits] =
      text
      |> String.split()
      |> Enum.map(&to_charlist/1)
      |> Enum.map(&Enum.sort/1)
      |> Enum.chunk_by(&(&1 == '|'))

    %{unique_digits: unique_digits, output_digits: output_digits}
  end

  def count_easy_spots(inputs) do
    inputs
    |> Enum.map(fn input ->
      decoded = decode_signal(input.unique_digits)

      Enum.count(input.output_digits, &(decoded[&1] in [1, 4, 7, 8]))
    end)
    |> Enum.sum()
  end

  def count_all(inputs) do
    inputs
    |> Enum.map(fn input ->
      decoded = decode_signal(input.unique_digits)

      input.output_digits
      |> Enum.map(fn output -> decoded[output] end)
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  def decode_display(inputs) do
    inputs
    |> Enum.map(fn input ->
      decoded = decode_signal(input.unique_digits)
      Enum.map(input.output_digits, fn val -> decoded[val] end)
    end)
  end

  def decode_signal(ten_unique_signals) do
    ten_unique_signals
    |> Enum.group_by(&length/1)
    |> Enum.sort_by(fn {_, signals} -> length(signals) end)
    |> Enum.reduce(%{}, fn
      {2, [signal]}, acc ->
        acc
        |> Map.put(1, signal)
        |> Map.put(signal, 1)

      {3, [signal]}, acc ->
        acc
        |> Map.put(7, signal)
        |> Map.put(signal, 7)

      {4, [signal]}, acc ->
        acc
        |> Map.put(4, signal)
        |> Map.put(signal, 4)

      {7, [signal]}, acc ->
        acc
        |> Map.put(8, signal)
        |> Map.put(signal, 8)

      {5, signals}, acc ->
        three = find_three(signals, acc)

        remaining_signals = signals -- [three]

        five = find_five(remaining_signals, acc)

        [two] = remaining_signals -- [five]

        acc
        |> Map.put(2, two)
        |> Map.put(two, 2)
        |> Map.put(3, three)
        |> Map.put(three, 3)
        |> Map.put(5, five)
        |> Map.put(five, 5)

      {6, signals}, acc ->
        six = find_six(signals, acc)
        remaining_signals = signals -- [six]

        nine = find_nine(remaining_signals, acc)

        [zero] = remaining_signals -- [nine]

        acc
        |> Map.put(6, six)
        |> Map.put(six, 6)
        |> Map.put(9, nine)
        |> Map.put(nine, 9)
        |> Map.put(0, zero)
        |> Map.put(zero, 0)
    end)
  end

  defp find_three(signals, acc) do
    Enum.find(signals, fn signal ->
      [] == to_charlist(acc[1]) -- to_charlist(signal)
    end)
  end

  defp find_five(signals, acc) do
    Enum.find(signals, fn signal ->
      diff = to_charlist(acc[4]) -- to_charlist(signal)
      length(diff) == 1
    end)
  end

  defp find_six(signals, acc) do
    Enum.find(signals, fn signal ->
      diff = to_charlist(acc[1]) -- to_charlist(signal)
      length(diff) == 1
    end)
  end

  defp find_nine(signals, acc) do
    Enum.find(signals, fn signal ->
      diff = to_charlist(signal) -- to_charlist(acc[5])
      length(diff) == 1
    end)
  end
end

inputs = DisplaySignal.read_from_disk!()

IO.puts("Day 8 - Example 1 - #{DisplaySignal.count_easy_spots(inputs)}")
IO.puts("Day 8 - Example 2 - #{DisplaySignal.count_all(inputs)}")
