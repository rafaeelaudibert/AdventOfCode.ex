defmodule AdventOfCode.Day18Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day18.part1(AdventOfCode.Helpers.File.get_path(18))
    assert result === 45_840_336_521_334
  end

  test "part2" do
    result = AdventOfCode.Day18.part2(AdventOfCode.Helpers.File.get_path(18))
    assert result === 328_920_644_404_583
  end
end
