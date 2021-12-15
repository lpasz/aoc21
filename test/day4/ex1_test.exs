defmodule AdventOfCode2021.Day4.Exercise1Test do
  use ExUnit.Case
  import AdventOfCode2021.Day4.Exercise1

  setup_all do
    {caller, boards} = read_from_disk!("test/day4/inputs.txt")

    [caller: caller, boards: boards]
  end

  test "info of winning board in boards", %{caller: caller, boards: boards} do
    {_board, board_win} = get_winning_board(boards, caller)

    assert board_win.round == 12
    assert board_win.line == [14, 21, 17, 24, 4]
    assert board_win.column == nil
    assert board_win.called == Enum.reverse([7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24])
  end

  test "score of winning board in boards", %{caller: caller, boards: boards} do
    assert boards |> get_winning_board(caller) |> calc_boards_points() == 4512
  end
end
