defmodule AdventOfCode.Day07Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day07.part1(AdventOfCode.Helpers.File.get_path(7))
    assert result == 248
  end

  test "part2" do
    result = AdventOfCode.Day07.part2(AdventOfCode.Helpers.File.get_path(7))
    assert result == 57281
  end
end
