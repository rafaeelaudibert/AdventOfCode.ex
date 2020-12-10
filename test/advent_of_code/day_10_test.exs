defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day10.part1(AdventOfCode.Helpers.File.get_path(10))
    assert result == 2244
  end

  test "part2" do
    result = AdventOfCode.Day10.part2(AdventOfCode.Helpers.File.get_path(10))
    assert result == 3_947_645_370_368
  end
end
