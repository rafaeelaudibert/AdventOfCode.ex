import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day13 do
  @spec part1(String.t()) :: non_neg_integer()
  def part1(test_filename) do
    [depart, buses] = read_lines(test_filename)

    depart = Integer.parse(depart) |> elem(0)

    buses =
      String.split(buses, ",")
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(fn bus -> bus |> Integer.parse() |> elem(0) end)

    Stream.iterate(depart, &(&1 + 1))
    |> Enum.find_value(fn time ->
      bus = Enum.find(buses, fn bus -> rem(time, bus) == 0 end)
      if bus, do: bus * (time - depart)
    end)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(test_filename) do
    [_, buses] = read_lines(test_filename)

    buses =
      String.split(buses, ",")
      |> Enum.with_index()
      |> Enum.filter(fn {val, _} -> val != "x" end)
      |> Enum.map(fn {bus, idx} -> {bus |> Integer.parse() |> elem(0), idx} end)

    mods = Enum.map(buses, &elem(&1, 0))
    remainders = Enum.map(buses, fn {bus, idx} -> rem(-idx + bus * 10, bus) end)
    Math.chinese_remainder(mods, remainders)
  end
end
