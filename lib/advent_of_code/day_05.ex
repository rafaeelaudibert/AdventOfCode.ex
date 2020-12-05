import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day05 do
  use Bitwise

  defp parse_to_binary(items) do
    Enum.reduce(items, 0, fn y, acc -> (acc <<< 1) + if y in ~w[B R], do: 1, else: 0 end)
  end

  @spec get_input(String.t()) :: non_neg_integer()
  defp get_input(test_filename) do
    read_lines(test_filename)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(& &1 |> parse_to_binary())
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(test_filename) do
    get_input(test_filename) |> Enum.max()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(test_filename) do
    numbers = get_input(test_filename) |> MapSet.new()
    
    Stream.iterate(1, & &1 + 1)
      |> Enum.find(& &1 - 1 in numbers and &1 + 1 in numbers and &1 not in numbers)
  end
end
