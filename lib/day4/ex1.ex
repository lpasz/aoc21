defmodule AdventOfCode2021.Day4.Exercise1 do
  def read_from_disk!(path \\ "./lib/day4/input.txt") do
    [caller_raw | boards_raw] = path |> File.read!() |> String.split("\n")

    caller = parse_called(caller_raw)

    boards_raw = parse_boards(boards_raw)

    {caller, boards_raw}
  end

  defp parse_called(caller_raw) do
    caller_raw
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_boards(boards_raw) do
    boards_raw
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&parse_board/1)
  end

  defp parse_board(matrix) do
    matrix
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse_board_line/1)
  end

  defp parse_board_line(line) do
    line
    |> Enum.map(&String.to_integer/1)
  end

  @spec calc_boards_points({list, atom | %{:called => [...], optional(any) => any}}) :: number
  def calc_boards_points({board, board_results}) do
    unmarked_numbers = List.flatten(board) -- board_results.called

    sum_of_unmarked_numbers = Enum.sum(unmarked_numbers)

    [last_called | _] = board_results.called

    sum_of_unmarked_numbers * last_called
  end

  def get_winning_board(boards, caller) do
    boards
    |> Enum.map(&{&1, board_win_at(&1, caller)})
    |> Enum.sort_by(&elem(&1, 1).round)
    |> List.first()
  end

  def get_losing_board(boards, caller) do
    boards
    |> Enum.map(&{&1, board_win_at(&1, caller)})
    |> Enum.sort_by(&elem(&1, 1).round, :desc)
    |> List.first()
  end

  def board_win_at(board, caller) do
    do_board_win_at(board, [], caller)
  end

  defp do_board_win_at(board, called, [head | rest]) do
    complete_line = Enum.find(board, &(&1 -- called == []))
    complete_column = board |> Enum.zip_with(& &1) |> Enum.find(&(&1 -- called == []))

    if complete_line || complete_column do
      %{
        called: called,
        column: complete_column,
        line: complete_line,
        round: length(called)
      }
    else
      do_board_win_at(board, [head | called], rest)
    end
  end
end

{called, boards} = AdventOfCode2021.Day4.Exercise1.read_from_disk!()
{board, board_info} = AdventOfCode2021.Day4.Exercise1.get_winning_board(boards, called)
result = AdventOfCode2021.Day4.Exercise1.calc_boards_points({board, board_info})

IO.puts("Day 4 - Exercise 1 - Result #{result}")


{board, board_info} = AdventOfCode2021.Day4.Exercise1.get_losing_board(boards, called)
result = AdventOfCode2021.Day4.Exercise1.calc_boards_points({board, board_info})

IO.puts("Day 4 - Exercise 2 - Result #{result}")
