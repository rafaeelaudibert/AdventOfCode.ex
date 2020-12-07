defmodule AdventOfCode.Day01Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day01.part1(AdventOfCode.Helpers.File.get_path(1))
    assert result == 618_144
  end

  test "part2" do
    result = AdventOfCode.Day01.part2(AdventOfCode.Helpers.File.get_path(1))
    assert result == 173_538_720
  end
end
