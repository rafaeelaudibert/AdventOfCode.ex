defmodule AdventOfCode.Day20Test do
  use ExUnit.Case

  @tag :too_slow
  test "part1" do
    result = AdventOfCode.Day20.part1(AdventOfCode.Helpers.File.get_path(20))
    assert result == 17_148_689_442_341
  end

  @tag :too_slow
  test "part2" do
    result = AdventOfCode.Day20.part2(AdventOfCode.Helpers.File.get_path(20))
    assert result == 2009
  end
end
