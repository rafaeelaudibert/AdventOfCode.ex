defmodule AdventOfCode.Day03Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day03.part1(AdventOfCode.Helpers.File.get_path(3))
    assert result == 218
  end

  test "part2" do
    result = AdventOfCode.Day03.part2(AdventOfCode.Helpers.File.get_path(3))
    assert result == 3_847_183_340
  end
end
