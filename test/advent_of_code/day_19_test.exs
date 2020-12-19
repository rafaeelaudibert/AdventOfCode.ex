defmodule AdventOfCode.Day19Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day19.part1(AdventOfCode.Helpers.File.get_path(19))
    assert result === 241
  end

  test "part2" do
    result = AdventOfCode.Day19.part2(AdventOfCode.Helpers.File.get_path(19))
    assert result === 424
  end
end
