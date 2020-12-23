defmodule AdventOfCode.Day21Test do
  use ExUnit.Case

  test "part1" do
    result = AdventOfCode.Day21.part1(AdventOfCode.Helpers.File.get_path(21))
    assert result === 1882
  end

  test "part2" do
    result = AdventOfCode.Day21.part2(AdventOfCode.Helpers.File.get_path(21))
    assert result === "xgtj,ztdctgq,bdnrnx,cdvjp,jdggtft,mdbq,rmd,lgllb"
  end
end
