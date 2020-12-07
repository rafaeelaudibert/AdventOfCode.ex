defmodule AdventOfCode.Day06Test do
  use ExUnit.Case
  
  test "part1" do
    result = AdventOfCode.Day06.part1(AdventOfCode.Helpers.File.get_path(6))
    assert result == 6778
  end

  test "part2" do
    result = AdventOfCode.Day06.part2(AdventOfCode.Helpers.File.get_path(6))
    assert result == 3406
  end
end
