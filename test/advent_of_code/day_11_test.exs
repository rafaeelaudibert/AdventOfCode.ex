defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  @tag :too_slow
  test "part1" do
    result = AdventOfCode.Day11.part1(AdventOfCode.Helpers.File.get_path(11))
    assert result == 2273
  end

  @tag :too_slow
  test "part2" do
    result = AdventOfCode.Day11.part2(AdventOfCode.Helpers.File.get_path(11))
    assert result == 2064
  end
end
