defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day05.part1(AdventOfCode.Helpers.File.get_path(5))
    assert result === 835
  end

  test "part2" do
    result = AdventOfCode.Day05.part2(AdventOfCode.Helpers.File.get_path(5))
    assert result === 649
  end
end
