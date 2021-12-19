defmodule DumboOctopusTest do
  use ExUnit.Case
  import DumboOctopus

  describe "setup 1" do
    setup do
      [input: read_from_disk!("test/day11/input.txt")]
    end

    test "single step goes well", %{input: input} do
      assert {result, 9} = apply_single_step(input)

      assert read_from_disk!("test/day11/test1.txt") == result

      assert {result, 0} = apply_single_step(result)
      assert read_from_disk!("test/day11/test2.txt") == result
    end
  end

  describe "setup 2" do
    setup do
      [input: read_from_disk!("test/day11/input2.txt")]
    end

    test "after many steps, how many flashes where fired", %{input: input} do
      assert 1656 == apply_steps(input, 100)
    end
  end

  describe "setup 3" do
    setup do
      [input: read_from_disk!("test/day11/input2.txt")]
    end

    test "when all fire at once", %{input: input} do
      size = input |> Enum.to_list() |> length()
      assert 195 == when_all_flash_sync(input, size)
    end
  end
end
