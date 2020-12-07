import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day03 do
  @spec compute_trees([[String.t()]], {non_neg_integer, non_neg_integer}) :: non_neg_integer
  defp compute_trees(matrix, {slope_x, slope_y}) do
    size = length(matrix)
    size_inside = List.first(matrix) |> length()

    Stream.take_every(0..(size - 1), slope_y)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {x, idx}, acc ->
      if Enum.at(matrix, x) |> Enum.at(rem(slope_x * idx, size_inside)) == "#",
        do: acc + 1,
        else: acc
    end)
  end

  @spec part1(String.t()) :: non_neg_integer
  def part1(test_filename) do
    read_lines(test_filename)
    |> Enum.map(&String.graphemes/1)
    |> compute_trees({3, 1})
  end

  @spec part2(String.t()) :: non_neg_integer
  def part2(test_filename) do
    matrix = read_lines(test_filename) |> Enum.map(&String.graphemes/1)
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    slopes
    |> Enum.map(&compute_trees(matrix, &1))
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end
