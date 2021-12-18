defmodule DisplaySignalTest do
  use ExUnit.Case
  import DisplaySignal

  @single_line_input "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"

  test "correctly formats input" do
    assert %{
             output_digits: ['bcdef', 'abcdf', 'bcdef', 'abcdf'],
             unique_digits: [
               'abcdefg',
               'bcdef',
               'acdfg',
               'abcdf',
               'abd',
               'abcdef',
               'bcdefg',
               'abef',
               'abcdeg',
               'ab'
             ]
           } == format_input_text(@single_line_input)
  end

  setup_all do
    [input: format_input_text(@single_line_input)]
  end

  test "discover the numbers in unique signal", %{input: inputs} do
    result = decode_signal(inputs.unique_digits)

    assert %{
             0 => 'abcdeg',
             1 => 'ab',
             2 => 'acdfg',
             3 => 'abcdf',
             4 => 'abef',
             5 => 'bcdef',
             6 => 'bcdefg',
             7 => 'abd',
             8 => 'abcdefg',
             9 => 'abcdef'
           } = result

    assert %{
             'ab' => 1,
             'abcdef' => 9,
             'abcdefg' => 8,
             'abcdeg' => 0,
             'abcdf' => 3,
             'abd' => 7,
             'abef' => 4,
             'acdfg' => 2,
             'bcdef' => 5,
             'bcdefg' => 6
           } = result
  end

  test "discover the numbers in output signal", %{input: input} do
    assert [[5, 3, 5, 3]] == decode_display([input])
  end

  test "count all line one", %{input: input} do
    assert 5353 == count_all([input])
  end

  setup_all do
    [inputs: read_from_disk!("test/day8/input.txt")]
  end

  test "count easy spots", %{inputs: inputs} do
    assert 26 == count_easy_spots(inputs)
  end

  test "count all", %{inputs: inputs} do
    assert 61229 == count_all(inputs)
  end
end
