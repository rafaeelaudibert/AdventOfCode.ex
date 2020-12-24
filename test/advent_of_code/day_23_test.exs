defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day23.part1(AdventOfCode.Helpers.File.get_path(23))
    assert result == "43769582"
  end

  @tag :too_slow
  test "part2" do
    result = AdventOfCode.Day23.part2(AdventOfCode.Helpers.File.get_path(23))
    assert result === 264_692_662_390
  end
end
