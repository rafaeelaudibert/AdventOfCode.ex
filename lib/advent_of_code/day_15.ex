import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day15 do
  @spec solve(non_neg_integer(), non_neg_integer(), Map.t(), non_neg_integer()) ::
          non_neg_integer()
  defp solve(curr_index, last_number, _, limit)
       when curr_index == limit + 1,
       do: last_number

  defp solve(curr_index, last_number, map, limit) do
    list_size = curr_index - 1

    {last_index, map} =
      Map.get_and_update(map, last_number, fn current_value ->
        {
          if(current_value != nil, do: current_value, else: list_size),
          list_size
        }
      end)

    solve(curr_index + 1, list_size - last_index, map, limit)
  end

  @spec solve(String.t(), non_neg_integer()) :: non_neg_integer()
  defp solve(filename, limit) do
    input =
      read_line(filename)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

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
