defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day09.part1(AdventOfCode.Helpers.File.get_path(9))
    assert result == 50_047_984
  end

  test "part2" do
    result = AdventOfCode.Day09.part2(AdventOfCode.Helpers.File.get_path(9))
    assert result == 5_407_707
  end
end
