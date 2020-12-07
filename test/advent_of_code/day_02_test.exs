defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day02.part1(AdventOfCode.Helpers.File.get_path(2))
    assert result == 660
  end

  test "part2" do
    result = AdventOfCode.Day02.part2(AdventOfCode.Helpers.File.get_path(2))
    assert result == 530
  end
end
