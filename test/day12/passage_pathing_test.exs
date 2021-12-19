defmodule PassagePathingTest do
  use ExUnit.Case
  import PassagePathing

  describe "input 1" do
    setup do
      [input: read_from_disk!("test/day12/input1.txt")]
    end

    test "read and parse file", %{input: input} do
      assert %{
               "end" => ["b", "A"],
               "start" => ["b", "A"],
               "A" => ["end", "b", "c", "start"],
               "b" => ["end", "d", "A", "start"],
               "c" => ["A"],
               "d" => ["b"]
             } == input
    end

    test "all paths", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])
        |> Enum.map(&Enum.reverse/1)

      assert length(result) == 10

      assert [
               ~w(start A b A c A end),
               ~w(start A b A end),
               ~w(start A b end),
               ~w(start A c A b A end),
               ~w(start A c A b end),
               ~w(start A c A end),
               ~w(start A end),
               ~w(start b A c A end),
               ~w(start b A end),
               ~w(start b end)
             ] == result
    end

    test "all paths 2", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])

      assert length(result) == 36
    end
  end

  describe "input 2" do
    setup do
      [input: read_from_disk!("test/day12/input.txt")]
    end

    test "all paths", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])
        |> Enum.map(&Enum.reverse/1)

      assert length(result) == 19

      assert [] ==
               [
                 ~w(start HN dc HN end),
                 ~w(start HN dc HN kj HN end),
                 ~w(start HN dc end),
                 ~w(start HN dc kj HN end),
                 ~w(start HN end),
                 ~w(start HN kj HN dc HN end),
                 ~w(start HN kj HN dc end),
                 ~w(start HN kj HN end),
                 ~w(start HN kj dc HN end),
                 ~w(start HN kj dc end),
                 ~w(start dc HN end),
                 ~w(start dc HN kj HN end),
                 ~w(start dc end),
                 ~w(start dc kj HN end),
                 ~w(start kj HN dc HN end),
                 ~w(start kj HN dc end),
                 ~w(start kj HN end),
                 ~w(start kj dc HN end),
                 ~w(start kj dc end)
               ] -- result
    end

    test "all paths 2", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])

      assert length(result) == 103
    end
  end

  describe "input 3" do
    setup do
      [input: read_from_disk!("test/day12/input2.txt")]
    end

    test "all paths", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])
        |> Enum.map(&Enum.reverse/1)

      assert length(result) == 226
    end

    test "all paths 2", %{input: input} do
      result =
        input
        |> find_all_paths("start", [], [], [])

      assert length(result) == 3509
    end
  end
end
