defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day15.part1(AdventOfCode.Helpers.File.get_path(15))
    assert result == 468
  end

  @tag :too_slow
  test "part2" do
    result = AdventOfCode.Day15.part2(AdventOfCode.Helpers.File.get_path(15))
    assert result == 1_801_753
  end
end
