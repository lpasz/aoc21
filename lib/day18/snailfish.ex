defmodule Snailfish do
  def part_1 do
    Snailfish.Input.puzzle_input()
    |> sum_snailfish()
    |> Snailfish.Magnitude.magnitude()
  end

  def part_2(puzzle_input \\ Snailfish.Input.puzzle_input()) do
    for p1 <- puzzle_input, p2 <- puzzle_input, reduce: 0 do
      acc ->
        sum = sum_snailfish(p1, p2)
        mag = Snailfish.Magnitude.magnitude(sum)

        if mag > acc, do: mag, else: acc
    end
  end

  def sum_snailfish([snailfish1, snailfish2 | snailfishes]) do
    snailfish_result = sum_snailfish(snailfish1, snailfish2)

    case snailfishes do
      [] -> snailfish_result
      _ -> sum_snailfish([snailfish_result | snailfishes])
    end
  end

  def sum_snailfish(snailfish1, snailfish2) do
    [snailfish1, snailfish2]
    # |> IO.inspect(charlists: :as_lists)
    |> reduce_sum()
  end

  def reduce_sum(snailfish) do
    # IO.inspect(snailfish,label: :reduce_sum, charlists: :as_lists)
    case Snailfish.Explode.explode(snailfish) do
      {:ok, snailfish} ->
        reduce_sum(snailfish)

      :error ->
        case Snailfish.Split.split(snailfish) do
          {:ok, snailfish} -> reduce_sum(snailfish)
          :error -> snailfish
        end
    end
  end
end
