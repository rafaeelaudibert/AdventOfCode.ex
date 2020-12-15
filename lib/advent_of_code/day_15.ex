import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day15 do
  @spec solve(non_neg_integer(), non_neg_integer(), Map.t(), non_neg_integer()) ::
          non_neg_integer()
  defp solve(curr_index, last_number, _, limit)
       when curr_index == limit + 1,
       do: last_number

  defp solve(curr_index, last_number, map, limit) do
    # We use the default as list_size, so that we don't need an "if"
    # This is because when the number hasn't being used we have the following:
    # list_size - last_index = list_size - list_size = 0
    list_size = curr_index - 1
    last_index = Map.get(map, last_number, list_size)

    new_number = list_size - last_index
    map = Map.put(map, last_number, list_size)
    solve(curr_index + 1, new_number, map, limit)
  end

  @spec solve(String.t(), non_neg_integer()) :: non_neg_integer()
  defp solve(filename, limit) do
    input =
      read_lines(filename)
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&(&1 |> Integer.parse() |> elem(0)))

    solve(
      length(input) + 1,
      List.last(input),
      Enum.with_index(input)
      |> Enum.map(fn {val, idx} -> {val, idx + 1} end)
      |> Map.new(),
      limit
    )
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename), do: solve(filename, 2020)

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename), do: solve(filename, 30_000_000)
end
