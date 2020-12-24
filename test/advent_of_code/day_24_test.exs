defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day24.part1(AdventOfCode.Helpers.File.get_path(24))
    assert result == 360
  end

  test "part2" do
    result = AdventOfCode.Day24.part2(AdventOfCode.Helpers.File.get_path(24))
    assert result == 3924
  end
end
