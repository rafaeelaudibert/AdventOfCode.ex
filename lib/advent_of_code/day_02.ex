import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day02 do
  @type password() :: {non_neg_integer(), non_neg_integer(), String.t(), String.t()}

  @spec parse_line(String.t()) :: password()
  defp parse_line(content) do
    [digits, letter, password] = String.split(content, " ")
    [{digit_0, _}, {digit_1, _}] = String.split(digits, "-") |> Enum.map(&Integer.parse/1)
    letter = String.slice(letter, 0..0)

    {digit_0, digit_1, letter, password}
  end

  @spec is_on_range(password()) :: boolean()
  defp is_on_range({digit_0, digit_1, letter, password}) do
    count = password |> String.graphemes() |> Enum.count(fn x -> x == letter end)
    count >= digit_0 and count <= digit_1
  end

  @spec is_on_positions(password()) :: boolean()
  defp is_on_positions({position_0, position_1, letter, password}) do
    graphemes = password |> String.graphemes()
    at_0 = Enum.at(graphemes, position_0 - 1) == letter
    at_1 = Enum.at(graphemes, position_1 - 1) == letter
    (at_0 && !at_1) || (!at_0 && at_1)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&is_on_range/1)
    |> Enum.count(& &1)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> Enum.map(&parse_line/1)
    |> Enum.map(&is_on_positions/1)
    |> Enum.count(& &1)
  end
end
