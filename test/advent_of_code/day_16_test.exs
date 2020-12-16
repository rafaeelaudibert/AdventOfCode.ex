defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day16.part1(AdventOfCode.Helpers.File.get_path(16))
    assert result == 26053
  end

  test "part2" do
    result = AdventOfCode.Day16.part2(AdventOfCode.Helpers.File.get_path(16))
    assert result == 1_515_506_256_421
  end
end
