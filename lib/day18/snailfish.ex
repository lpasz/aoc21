defmodule Snailfish do
  @input __MODULE__.Input.get()
  @example __MODULE__.Input.get_example()
  def part_1_example do
    [
      [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
      [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
      [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
      [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
      [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
      [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
      [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
      [[9, 3], [[9, 9], [6, [4, 9]]]],
      [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
      [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]]
    ]
  end

  def sf_sum(sf1, sf2) do
    IO.puts("Next Sum Started")

    (sf1 ++ sf2)
    |> Enum.map(&Map.update(&1, :depth, 0, fn x -> x + 1 end))
    |> reduce_sum()
  end

  def reduce_sum(fs) do
    {explode?, fs} = explode(fs)

    if explode? do
      reduce_sum(fs)
    else
      {split?, fs} = split(fs)

      if split? do
        reduce_sum(fs)
      else
        fs
      end
    end
  end

  def calc_magnitude(fs) do
    max_depth = Enum.map(fs, & &1.depth) |> Enum.max()

    fi = Enum.find_index(fs, &(&1.depth == max_depth))

    val_1 = Enum.fetch!(fs, fi)
    val_2 = Enum.fetch!(fs, fi + 1)

    f = %{val: 3 * val_1.val + 2 * val_2.val, depth: max_depth - 1}

    fs =
      fs
      |> List.delete_at(fi + 1)
      |> List.replace_at(fi, f)

    if length(fs) == 1 do
      hd(fs).val
    else
      calc_magnitude(fs)
    end
  end

  def format_sum_snailfish(snailfish_sum) do
    snailfish_sum
    |> format_sum_snailfish(0)
    |> List.flatten()
  end

  def format_sum_snailfish([], _), do: []

  def format_sum_snailfish([sf1, sf2], depth) do
    [format_sum_snailfish(sf1, depth + 1), format_sum_snailfish(sf2, depth + 1)]
  end

  def format_sum_snailfish(sf_val, depth), do: %{val: sf_val, depth: depth}

  def explode(fs) do
    if i = Enum.find_index(fs, &(&1.depth > 4)) do
      prev_i = i - 1
      prev = if prev_i != -1, do: Enum.fetch(fs, prev_i), else: :error

      curr1_i = i
      curr1 = Enum.fetch(fs, curr1_i)

      curr2_i = i + 1
      curr2 = Enum.fetch(fs, curr2_i)

      next_i = i + 2
      next = Enum.fetch(fs, next_i)

      fs =
        case {prev, curr1, curr2, next} do
          {:error, {:ok, curr1_val}, {:ok, curr2_val}, {:ok, next_val}} ->

            fs
            |> List.replace_at(curr1_i, %{val: 0, depth: curr1_val.depth - 1})
            |> List.replace_at(curr2_i, %{
              val: curr2_val.val + next_val.val,
              depth: next_val.depth
            })
            |> List.delete_at(next_i)

          {{:ok, prev_val}, {:ok, curr1_val}, {:ok, curr2_val}, {:ok, next_val}} ->
            IO.inspect(:all)

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
            IO.puts(:no_next)

            fs
            |> List.replace_at(prev_i, %{
              val: curr1_val.val + prev_val.val,
              depth: curr1_val.depth - 1
            })
            |> List.replace_at(curr2_i, %{val: 0, depth: curr2_val.depth - 1})
            |> List.delete_at(curr1_i)
        end

      {true, fs}
    else
      {false, fs}
    end
  end

  def split(fs) do
    if Enum.any?(fs, fn %{val: v} -> v > 10 end) do
      fs =
        Enum.flat_map(fs, fn %{depth: d, val: v} ->
          if v >= 10 do
            [%{depth: d + 1, val: div(v, 2)}, %{depth: d + 1, val: round(v / 2)}]
          else
            [%{depth: d, val: v}]
          end
        end)

      {true, fs}
    else
      {false, fs}
    end
  end
end
