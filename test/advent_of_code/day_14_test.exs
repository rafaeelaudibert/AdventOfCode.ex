defmodule AdventOfCode.Day14Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day14.part1(AdventOfCode.Helpers.File.get_path(14))
    assert result == 17_028_179_706_934
  end

  test "part2" do
    result = AdventOfCode.Day14.part2(AdventOfCode.Helpers.File.get_path(14))
    assert result == 3_683_236_147_222
  end
end
