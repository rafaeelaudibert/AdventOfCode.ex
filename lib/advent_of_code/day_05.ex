import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day05 do
  use Bitwise, only_operators: true

  @spec parse_to_binary([String.t()]) :: non_neg_integer()
  defp parse_to_binary(items) do
    Enum.reduce(items, 0, fn y, acc -> (acc <<< 1) + if y in ~w[B R], do: 1, else: 0 end)
  end

  @spec get_input(String.t()) :: [non_neg_integer()]
  defp get_input(filename) do
    read_lines(filename)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&parse_to_binary/1)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    get_input(filename) |> Enum.max()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    numbers = get_input(filename) |> MapSet.new()

    Stream.iterate(Enum.min(numbers), &(&1 + 1))
    |> Enum.find(&(&1 not in numbers))
  end
end
