defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day25.part1(AdventOfCode.Helpers.File.get_path(25))
    assert result === 17_980_581
  end

  test "part2" do
    result = AdventOfCode.Day25.part2(AdventOfCode.Helpers.File.get_path(25))
    assert result === 2020
  end
end
