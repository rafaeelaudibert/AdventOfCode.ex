defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day12.part1(AdventOfCode.Helpers.File.get_path(12))
    assert result == 858
  end

  test "part2" do
    result = AdventOfCode.Day12.part2(AdventOfCode.Helpers.File.get_path(12))
    assert result == 39140
  end
end
