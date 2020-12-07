defmodule AdventOfCode.Day04Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day04.part1(AdventOfCode.Helpers.File.get_path(4))
    assert result == 222
  end

  test "part2" do
    result = AdventOfCode.Day04.part2(AdventOfCode.Helpers.File.get_path(4))
    assert result == 140
  end
end
