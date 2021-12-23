defmodule ExtendedPolymerizationTest do
  use ExUnit.Case

  import ExtendedPolymerization

  setup do
    {input, lookup} = read_from_disk!("test/day14/input.txt")
    [initial: input, lookup_table: lookup]
  end

  test "steps correctly", %{initial: initial, lookup_table: lookup_table} do
    step1 = polymerization(initial, lookup_table)
    step2 = polymerization(step1, lookup_table)
    step3 = polymerization(step2, lookup_table)
    step4 = polymerization(step3, lookup_table)

    assert String.codepoints("NCNBCHB") == step1
    assert String.codepoints("NBCCNBBBCBHCB") == step2
    assert String.codepoints("NBBBCNCCNBBNBNBBCHBHHBCHB") == step3
    assert String.codepoints("NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB") == step4
  end
end
