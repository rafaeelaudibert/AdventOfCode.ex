import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day02 do
  @type password() :: {non_neg_integer(), non_neg_integer(), String.t(), String.t()}

  @spec parse_line(String.t()) :: password()
  defp parse_line(content) do
    [digit_0, digit_1, letter, password] = String.split(content, [" ", "-", ":"], trim: true)

    {String.to_integer(digit_0), String.to_integer(digit_1), letter, password}
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
    |> Enum.count(&is_on_range/1)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> Enum.map(&parse_line/1)
    |> Enum.count(&is_on_positions/1)
  end
end
