defmodule Snailfish do
  def part_1_example do
    sf_sum([[[[4, 3], 4], 4], [7, [[8, 4], 9]]], [1, 1])
  end

  def sf_sum(sf1, sf2) do
    sum_snailfish = format_sum_snailfish([sf1, sf2])
  end

  def format_sum_snailfish(snailfish_sum) do
    snailfish_sum
    |> format_sum_snailfish(0)
    |> List.flatten()
  end

  def format_sum_snailfish([], _), do: []

  def format_sum_snailfish([sf1, sf2], depth) do
    IO.inspect([sf1, sf2])
    [format_sum_snailfish(sf1, depth + 1), format_sum_snailfish(sf2, depth + 1)]
  end

  def format_sum_snailfish(sf_val, depth), do: %{val: sf_val, depth: depth}

  def explode(fs) do
    i = Enum.find_index(fs, &(&1.depth > 4))

    prev_i = i - 1
    prev = if prev_i > 0, do: Enum.fetch(fs, prev_i), else: :error

    curr1_i = i
    curr1 = Enum.fetch(fs, curr1_i)

    curr2_i = i + 1
    curr2 = Enum.fetch(fs, curr2_i)

    next_i = i + 2
    next = Enum.fetch(fs, next_i)

    case {prev, curr1, curr2, next} do
      {:error, {:ok, curr1_val}, {:ok, curr2_val}, {:ok, next_val}} ->
        IO.puts("1")

        fs
        |> List.replace_at(curr1_i, %{val: 0, depth: curr1_val.depth - 1})
        |> List.replace_at(curr2_i, %{
          val: curr2_val.val + next_val.val,
          depth: curr2_val.depth - 1
        })
        |> List.delete_at(next_i)

      {{:ok, prev_val}, {:ok, curr1_val}, {:ok, curr2_val}, {:ok, next_val}} ->
        IO.puts("2")

        fs
        |> List.replace_at(prev_i, %{
          val: curr1_val.val + prev_val.val,
          depth: prev_val.depth
        })
        |> List.replace_at(next_i, %{
          val: curr2_val.val + next_val.val,
          depth: next_val.depth
        })
        |> List.replace_at(curr2_i, %{val: 0, depth: curr2_val.depth - 1})
        |> List.delete_at(curr1_i)

      {{:ok, prev_val}, {:ok, curr1_val}, {:ok, curr2_val}, :error} ->
        IO.puts("3")

        fs
        |> List.replace_at(curr1_i, %{
          val: curr1_val.val + prev_val.val,
          depth: curr1_val.depth - 1
        })
        |> List.replace_at(curr2_i, %{val: 0, depth: curr2_val.depth - 1})
        |> List.delete_at(prev_i)
    end
  end

  def split(fs) do

  end
end
