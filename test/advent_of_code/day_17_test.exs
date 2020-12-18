defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day17.part1(AdventOfCode.Helpers.File.get_path(17))
    assert result == 353
  end

  test "part2" do
    result = AdventOfCode.Day17.part2(AdventOfCode.Helpers.File.get_path(17))
    assert result == 2472
  end
end
