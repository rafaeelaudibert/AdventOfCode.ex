import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day06 do
  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_chunked_lines(filename)
    |> Enum.map(&(&1 |> Enum.join("") |> String.graphemes() |> Enum.uniq() |> length()))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_chunked_lines(filename)
    |> Enum.map(fn lines ->
      lines |> Enum.map(&(&1 |> String.split("", trim: true) |> MapSet.new()))
    end)
    |> Enum.map(fn lines ->
      lines |> Enum.reduce(fn answers, acc -> MapSet.intersection(acc, answers) end)
    end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end
end
