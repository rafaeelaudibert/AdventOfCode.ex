defmodule AdventOfCode.Day08Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day08.part1(AdventOfCode.Helpers.File.get_path(8))
    assert result == 1087
  end

  test "part2" do
    result = AdventOfCode.Day08.part2(AdventOfCode.Helpers.File.get_path(8))
    assert result == 780
  end
end
