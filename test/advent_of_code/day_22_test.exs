defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day22.part1(AdventOfCode.Helpers.File.get_path(22))
    assert result === 32033
  end

  test "part2" do
    result = AdventOfCode.Day22.part2(AdventOfCode.Helpers.File.get_path(22))
    assert result === 34901
  end
end
