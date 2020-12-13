defmodule AdventOfCode.Day13Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day13.part1(AdventOfCode.Helpers.File.get_path(13))
    assert result == 2045
  end

  test "part2" do
    result = AdventOfCode.Day13.part2(AdventOfCode.Helpers.File.get_path(13))
    assert result == 402_251_700_208_309
  end
end
